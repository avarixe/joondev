# == Schema Information
#
# Table name: my_fifa_players
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string           not null
#  pos         :string           not null
#  sec_pos     :string
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  start_ovr   :integer          default(0)
#  nationality :string
#  youth       :boolean          default(FALSE)
#  notes       :text
#  status      :string           default("")
#  start_value :integer          default(0)
#  start_age   :integer          default(0)
#

module MyFifa
  # Player in CareerMode Team
  class Player < Base
    default_scope { sorted.order(id: :asc) }

    belongs_to :team
    has_many :records, class_name: 'PlayerRecord', inverse_of: :player
    has_many :matches, through: :records

    has_many :player_seasons
    has_many :seasons, through: :player_seasons

    has_many :contracts, dependent: :destroy
    accepts_nested_attributes_for :contracts

    has_many :injuries, dependent: :delete_all
    has_many :loans, dependent: :delete_all

    serialize :sec_pos, Array

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    scope :with_stats, lambda { |match_ids|
      relevant_records = ' records.player_id = my_fifa_players.id'
      if match_ids.any?
        relevant_records +=
          ' AND records.match_id IN (' \
          "#{match_ids.any? ? match_ids.join(', ') : ''})"
      end
      joins('LEFT JOIN my_fifa_player_records ' \
            "AS records ON #{relevant_records}")
        .group('my_fifa_players.id')
        .select([
          'my_fifa_players.*',
          'COUNT(records) AS gp',
          'AVG(records.rating) AS rating',
          'SUM(records.goals) AS goals',
          'SUM(records.assists) AS assists',
          'SUM(CASE WHEN records.cs = TRUE THEN 1 ELSE 0 END) AS cs'
        ].join(', '))
    }

    scope :sorted, lambda {
      order([
        'CASE',
        *PLAYER_POSITIONS.map.with_index do |pos, i|
          "WHEN my_fifa_players.pos = '#{pos}' THEN #{i + 1}"
        end,
        'ELSE 100 END ASC'
      ].join(' '))
    }

    scope :available, -> { active.where(status: '') }

    scope :find_name, lambda { |term|
      find_by('LOWER(name) LIKE ?', "%#{term.downcase}%")
    }

    def self.grouped_by_pos(ungrouped_players)
      ungrouped_players.group_by(&:pos).map do |pos, players|
        [pos, players.map { |player| [player.name, player.id] }]
      end
    end

    ############################
    #  INITIALIZATION METHODS  #
    ############################
    def init(team_id)
      contracts.build(start_date: Team.find(team_id).current_date).init
      self
    end

    ########################
    #  ASSIGNMENT METHODS  #
    ########################
    def sec_pos=(val)
      pos_array = val.reject(&:blank?)
      write_attribute :sec_pos, pos_array
    end

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :name,        presence: { message: 'Name is blank.' }
    validates :nationality, presence: { message: 'Nationality is blank.' }
    validates :pos,         presence: { message: 'Position is blank.' }
    validates :start_age,   presence: { message: 'Age is blank.' }
    validates :start_ovr,   presence: { message: 'Start OVR Rating is blank.' }
    validates :start_value, presence: { message: 'Initial Value is blank.' }
    validate :no_transfer_if_youth?, on: :create, if: proc { |player| player.youth? }

    def no_transfer_if_youth?
      contract = contracts.first

      if contract.loan.present?
        errors.add(:base, 'A Youth Academy Players can\'t be a Loaned Player.')
      elsif contract.origin.present?
        errors.add(:base, 'Youth Academy Players should not have an Origin.')
      elsif dig(:contract, :transfer_cost, :fee) ||
            dig(:contract, :transfer_cost, :player_id)
        errors.add(:base, 'Youth Academy Players can\'t have a Transfer Cost.')
      end
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_create :create_player_season
    # after_commit :broadcast_change

    def create_player_season
      team.current_season.player_seasons.create(
        player_id: id,
        kit_no:    id,
        ovr:       start_ovr,
        value:     start_value,
        age:       start_age
      )
    end

    def broadcast_change
      PlayerStatusBroadcastJob.perform_now self
    end

    #####################
    #  MUTATOR METHODS  #
    #####################
    def toggle_injury(date, notes)
      if injured?
        update_column(:status, '') unless date.nil?
        injuries.last.update(end_date: date, notes: notes)
      else
        update_column(:status, 'injured')
        injuries.create(start_date: date, notes: notes)
      end
    end

    def toggle_loan(date, destination)
      if loaned_out?
        update_column(:status, '')
        loans.last.update(end_date: date)
      else
        # end any injury event
        injuries.where(end_date: nil).update_all(end_date: date)
        update_column(:status, 'loan')
        loans.create(start_date: date, destination: destination)
      end
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def date_joined
      contracts.first.start_date
    end

    def secondary_positions
      positions = sec_pos.join(', ')
      positions.blank? ? nil : positions
    end

    def national_flag
      "#{COUNTRY_FLAGS[nationality]} flag" if COUNTRY_FLAGS.key?(nationality)
    end

    def match_rating(match)
      record = records.find { |r| r.match_id == match.id }
      record.nil? ? 0 : record.rating
    end

    def season_value(season)
      season = player_seasons.find { |ps| ps.season_id == season.id }
      season.nil? ? 0 : season.value
    end

    def season_ovr(season)
      season = player_seasons.find { |ps| ps.season_id == season.id }
      season.nil? ? 0 : season.ovr
    end

    # rubocop:disable all
    def current_contract() contracts.last end
    def ovr()    player_seasons.last.ovr rescue start_ovr end
    def value()  player_seasons.last.value rescue start_value end
    def wage()   current_contract.terms.last.wage end
    def kit_no() player_sessions.last.kit_no rescue nil end
    def age()    player_seasons.last.age rescue start_age end
    def injury() injuries.last.notes end

    def injured?()    status == 'injured' end
    def loaned_out?() status == 'loan' end

    def rank()        gp + rating + goals * 3 + assists rescue 0 end
    def num_games()   records.count end
    def num_motm()    records.select { |r| r.motm? }.count end
    def num_goals()   records.map(&:goals).map(&:to_i).sum end
    def num_assists() records.map(&:assists).map(&:to_i).sum end
    def num_cs()      records.map(&:cs_to_i).sum end
    # rubocop:enable all
  end
end
