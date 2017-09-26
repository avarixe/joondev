module MyFifa
  class Player < Base
    self.table_name = 'my_fifa_players'
    default_scope { sorted.order(id: :asc) }

    belongs_to :team
    has_many :records, class_name: 'PlayerRecord'
    has_many :matches, through: :records

    has_many :contracts
    accepts_nested_attributes_for :contracts

    has_many :injuries
    has_many :loans

    serialize :sec_pos, Array

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    scope :with_stats, -> (match_ids) {
      relevant_records = " records.player_id = my_fifa_players.id"
      relevant_records += " AND records.match_id IN (#{match_ids.join(', ')})" if match_ids.any?
      joins("LEFT JOIN my_fifa_player_records AS records ON #{relevant_records}").group('my_fifa_players.id')
        .select([
          'my_fifa_players.*',
          "COUNT(records) as gp",
          "AVG(records.rating) as rating",
          "SUM(CASE WHEN records.goals IS NOT NULL THEN records.goals ELSE 0 END) as goals",
          "SUM(CASE WHEN records.assists IS NOT NULL THEN records.assists ELSE 0 END) as assists",
          "SUM(CASE WHEN records.cs = TRUE THEN 1 ELSE 0 END) as cs",
        ].join(', '))
    }

    scope :sorted, -> {
      order([
        'CASE',
        *POSITIONS.map.with_index{ |pos, i| "WHEN my_fifa_players.pos = '#{pos}' THEN #{i+1}" },
        'ELSE 100 END ASC'
      ].join(' '))
    }

    scope :uninjured, -> { where.not(status: 'injured') }

    POSITIONS = [
      'GK',
      'CB',
      'LB',
      'LWB',
      'RB',
      'RWB',
      'CDM',
      'CM',
      'LM',
      'RM',
      'LW',
      'RW',
      'CAM',
      'CF',
      'ST'
    ]

    ############################
    #  INITIALIZATION METHODS  #
    ############################
      def init(team_id)
        contracts.build(date_effective: Team.find(team_id).current_date).init
        return self
      end

    ########################
    #  ASSIGNMENT METHODS  #
    ########################

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :name,          presence: { message: "Name can't be blank." }
      validates :nationality,   presence: { message: "Nationality can't be blank." }
      validates :year_of_birth, presence: { message: "Year of Birth can't be blank." }
      validates :pos,           presence: { message: "Position can't be blank." }
      validates :start_ovr,     presence: { message: "Start OVR Rating can't be blank." }
      validate :no_transfer_if_youth?

      def no_transfer_if_youth?
        contract = contracts.first

        if self.youth? 
          if contract.loan.present?
            errors.add(:base, "A player cannot be both a Loaned Player and a Youth Academy Graduate.")            
          elsif contract.origin.present?
            errors.add(:base, "Youth Academy Graduates should not have an Origin.")            
          elsif [contract.transfer_cost.price, contract.transfer_cost.player_id].any?(&:present?)
            errors.add(:base, "Youth Academy Graduates should not have a Transfer Cost.")
          end
        end
      end

    ######################
    #  CALLBACK METHODS  #
    ######################

    #####################
    #  MUTATOR METHODS  #
    #####################
      def toggle_injury(date)
        if injured?
          self.update_column(:status, '')
          injuries.last.update(end_date: date)
        else
          self.update_column(:status, 'injured')
          injuries.create(start_date: date)
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
      def transfer_cost() self.contracts.first.transfer_cost end
      def exit_cost()     self.contracts.last.exit_cost end

      def shorthand_name
        names = self.name.split(' ')
        names.length == 1 ? self.name : "#{names.first[0]}. #{names.drop(1).join(' ')}"
      end

      def current_ovr
        self.records.last.ovr rescue self.start_ovr
      end

      def date_joined
        contracts.first.date_effective
      end

      def get_sec_pos
        positions = sec_pos.reject(&:blank?).join(", ")
        positions.blank? ? nil : positions
      end

      # STATUS
      def injured?()    status == 'injured' end
      def loaned_out?() status == 'loan' end

      # STATISTICS
      def num_games()   records.count end
      def num_motm()    records.select{ |r| r.motm? }.count end
      def num_goals()   records.map(&:goals).compact.inject(0, :+) end
      def num_assists() records.map(&:assists).compact.inject(0, :+) end
      def num_cs()      records.where(cs: 1).count end
  end
end
