module MyFifa
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

    scope :with_stats, -> (match_ids) {
      relevant_records = " records.player_id = my_fifa_players.id"
      relevant_records += " AND records.match_id IN (#{match_ids.any? ? match_ids.join(', ') : ""})" if match_ids.any?
      joins("LEFT JOIN my_fifa_player_records AS records ON #{relevant_records}")
      .group('my_fifa_players.id')
      .select([
        'my_fifa_players.*',
        "COUNT(records) AS gp",
        "AVG(records.rating) AS rating",
        "SUM(CASE WHEN records.goals IS NOT NULL THEN records.goals ELSE 0 END) AS goals",
        "SUM(CASE WHEN records.assists IS NOT NULL THEN records.assists ELSE 0 END) AS assists",
        "SUM(CASE WHEN records.cs = TRUE THEN 1 ELSE 0 END) AS cs",
      ].join(', '))
    }

    scope :sorted, -> {
      order([
        'CASE',
        *PLAYER_POSITIONS.map.with_index{ |pos, i| "WHEN my_fifa_players.pos = '#{pos}' THEN #{i+1}" },
        'ELSE 100 END ASC'
      ].join(' '))
    }

    scope :available, -> { where(status: "") }

    ############################
    #  INITIALIZATION METHODS  #
    ############################
      def init(team_id)
        contracts.build(start_date: Team.find(team_id).current_date).init
        return self
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
      validates :name,          presence: { message: "Name can't be blank." }
      validates :nationality,   presence: { message: "Nationality can't be blank." }
      validates :pos,           presence: { message: "Position can't be blank." }
      validates :start_age,     presence: { message: "Age can't be blank." }
      validates :start_ovr,     presence: { message: "Start OVR Rating can't be blank." }
      validates :start_value,   presence: { message: "Initial Value can't be blank." }
      validate :no_transfer_if_youth?

      def no_transfer_if_youth?
        contract = contracts.first

        if self.youth? 
          if contract.loan.present?
            errors.add(:base, "A player cannot be both a Loaned Player and a Youth Academy Graduate.")            
          elsif contract.origin.present?
            errors.add(:base, "Youth Academy Graduates should not have an Origin.")            
          elsif [contract.transfer_cost.fee, contract.transfer_cost.player_id].any?(&:present?)
            errors.add(:base, "Youth Academy Graduates should not have a Transfer Cost.")
          end
        end
      end

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :create_player_season
      
      def create_player_season
        self.team.current_season.player_seasons.create(
          player_id: self.id,
          kit_no:    self.id,
          ovr:       self.start_ovr,
          value:     self.start_value,
          age:       self.start_age
        )
      end

    #####################
    #  MUTATOR METHODS  #
    #####################
      def toggle_injury(date, notes)
        if injured?
          self.update_column(:status, "") unless date.nil?
          injuries.last.update(end_date: date, notes: notes)
        else
          self.update_column(:status, 'injured')
          injuries.create(start_date: date, notes: notes)
        end
      end

      def toggle_loan(date, destination)
        if loaned_out?
          self.update_column(:status, '')
          loans.last.update(end_date: date)
        else
          # end any injury event
          injuries.where(end_date: nil).update_all(end_date: date)
          self.update_column(:status, 'loan')
          loans.create(start_date: date, destination: destination)
        end
      end


    ######################
    #  ACCESSOR METHODS  #
    ######################
      def shorthand_name
        names = self.name.split(' ')
        names.length == 1 ? self.name : "#{names.first[0]}. #{names.drop(1).join(' ')}"
      end

      def date_joined
        contracts.first.start_date
      end

      def get_sec_pos
        positions = sec_pos.join(", ")
        positions.blank? ? nil : positions
      end

      def national_flag
        "#{COUNTRY_FLAGS[self.nationality]} flag" if COUNTRY_FLAGS.has_key?(self.nationality)
      end

      # CURRENT INFO
      def current_contract() self.contracts.last end
      def ovr()    self.player_seasons.last.ovr rescue self.start_ovr end
      def value()  self.player_seasons.last.value rescue self.start_value end
      def wage()   self.current_contract.terms.last.wage end
      def kit_no() self.player_sessions.last.kit_no rescue nil end
      def age()    self.player_seasons.last.age rescue self.start_age end
      def injury() self.injuries.last.notes end

      # STATUS
      def injured?()    status == 'injured' end
      def loaned_out?() status == 'loan' end

      # STATISTICS
      def rank()        self.gp + self.rating + self.goals * 3 + self.assists rescue 0 end
      def num_games()   records.count end
      def num_motm()    records.select{ |r| r.motm? }.count end
      def num_goals()   records.map(&:goals).map(&:to_i).sum end
      def num_assists() records.map(&:assists).map(&:to_i).sum end
      def num_cs()      records.map(&:cs_to_i).sum end

  end
end
