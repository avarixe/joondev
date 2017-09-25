module MyFifa
  class Match < Base
    self.table_name = 'my_fifa_matches'
    default_scope { order(id: :asc)}

    belongs_to :team
    has_many :player_records, -> { where record_id: nil }
    has_many :all_records, class_name: 'PlayerRecord'
    accepts_nested_attributes_for :player_records, reject_if: :invalid_record?
    has_many :players, through: :player_records

    belongs_to :motm, class_name: 'Player'
    scope :with_motm, -> { 
      joins('LEFT JOIN my_fifa_players ON my_fifa_matches.motm_id = my_fifa_players.id')
        .select('my_fifa_matches.*, my_fifa_players.name AS motm_name')
    }

    ############################
    #  INITIALIZATION METHODS  #
    ############################
      def build_records(formation)
        (1..11).each do |n|
          self.player_records.build(
            pos: formation.public_send("pos_#{n}")
          )
        end
      end

    ########################
    #  ASSIGNMENT METHODS  #
    ########################
      # score_f: GF (PF) 
      # score_a: GA (PA) 
      # score: GF (PF) - GA (PA) 
      %w(f a).each do |type|
        define_method "score_#{type}" do
          goals = self.send("score_g#{type}")
          penalties = self.send("penalties_g#{type}")
          "#{goals}#{penalties.present? ? " (#{penalties})" : ''}"
        end

        define_method "score_#{type}=" do |val|
          begin
            goals, penalties = val.match(/^(\d+)(?: \((\d+)\))*$/i).captures
            write_attribute :"score_g#{type}", goals
            write_attribute :"penalties_g#{type}", penalties
          rescue
          end
        end
      end

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :competition, presence: { message: "Competition can't be blank." }
      validates :opponent,    presence: { message: "Opponent Team can't be blank." }
      validates :date_played, presence: { message: "Date Played can't be blank." }
      validates :score_gf,    presence: { message: "Score can't be blank." }
      validates :score_ga,    presence: { if: -> { score_gf.present? }, message: "Score can't be blank." }
      validate :unique_players?

      def unique_players?
        player_ids = self.all_records.map(&:player_id).compact
        if player_ids.any?{ |id| player_ids.count(id) > 1 }
          errors.add(:base, "One Player has been selected at least twice.")
        end
      end

      def invalid_record?(attributed)
        attributed['pos'].blank?
      end

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_save :set_records
      after_save :update_current_date

      def set_records
        self.all_records.each do |record|
          record.update_columns(
            team_id: self.team_id,
            cs:      self.score_ga == 0,
          )
        end
      end

      def update_current_date
        if self.date_played > self.team.current_date
          self.team.update_column(:current_date, self.date_played)
        end
      end
    
    ######################
    #  INSTANCE METHODS  #
    ######################
      def player_ids
        self.player_records.inject([]){ |ids, record|
          ids + record.player_ids
        }
      end

      def score
        "#{self.score_f} - #{self.score_a}"
      end
          
      def result
        if self.score_gf > self.score_ga
          'positive'
        elsif self.score_gf == self.score_ga
          'warning'
        else
          'negative'
        end
      end
  end
end
