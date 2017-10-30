module MyFifa
  class Match < Base
    default_scope { order(id: :asc)}

    belongs_to :team
    has_many :player_records, -> { where(record_id: nil) }
    has_many :all_records, class_name: 'PlayerRecord'
    accepts_nested_attributes_for :player_records, allow_destroy: true, reject_if: :invalid_record?
    has_many :logs, class_name: "MatchLog"
    accepts_nested_attributes_for :logs, allow_destroy: true, reject_if: :invalid_log?
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
            pos: formation.public_send("pos_#{n}"),
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

      def invalid_log?(attributed)
        ['event', 'player1_id', 'minute'].any?{ |att| attributed[att].blank? }
      end

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_commit :set_records_match_data
      after_save :update_current_date
      after_save :save_external_match_data

      def set_records_match_data
        match_logs = self.logs.group_by(&:event)
        ["Goal", "Booking", "Injury"].each do |event|
          match_logs[event] ||= []
        end

        self.player_records.each do |record|
          current_record = record
          until current_record.nil? || current_record.destroyed?
            current_record.update_columns(
              team_id:      self.team_id,
              cs:           self.score_ga == 0,
              goals:        match_logs["Goal"].count{ |log| log.player1_id == record.player_id },
              assists:      match_logs["Goal"].count{ |log| log.player2_id == record.player_id },
              yellow_cards: match_logs["Booking"].count{ |log| log.player1_id == record.player_id && log.notes == "Yellow Card" },
              red_cards:    match_logs["Booking"].count{ |log| log.player1_id == record.player_id && log.notes == "Red Card" },
              injury:       (match_logs["Injury"].any?{ |log| log.player1_id == record.player_id } ? "injured" : nil)
            )
            current_record.create_event_if_injured if self.date_played == self.team.current_date
            current_record = current_record.sub_record
          end
        end
      end

      def update_current_date
        if self.date_played > self.team.current_date
          self.team.update_column(:current_date, self.date_played)
        end
      end
    
      def save_external_match_data
        unless self.team.teams_played.include? self.opponent
          self.team.teams_played << self.opponent
          self.team.save
        end
      end
    
    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def player_ids
        self.player_records.inject([]){ |ids, record|
          ids + record.player_ids
        }
      end

      def score
        "#{self.score_f} - #{self.score_a}"
      end
          
      def win?()  self.score_gf > self.score_ga end
      def draw?() self.score_gf == self.score_ga end
      def loss?() self.score_gf < self.score_ga end

      def result
        if win?
          'positive'
        elsif draw?
          ''
        else
          'negative'
        end
      end
  end
end
