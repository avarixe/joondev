# == Schema Information
#
# Table name: my_fifa_matches
#
#  id           :integer          not null, primary key
#  team_id      :integer
#  opponent     :string           not null
#  competition  :string           not null
#  score_gf     :integer          not null
#  score_ga     :integer          not null
#  penalties_gf :integer
#  penalties_ga :integer
#  date_played  :date
#  motm_id      :integer
#  home         :boolean          default(TRUE)
#  squad_id     :integer
#  season_id    :integer
#

module MyFifa
  # Match played during a Season
  class Match < Base
    default_scope { order(id: :asc) }

    belongs_to :team
    belongs_to :season
    belongs_to :motm, class_name: 'Player'

    has_many :player_records, -> { where(record_id: nil) }
    has_many :all_records, class_name: 'PlayerRecord'
    has_many :logs, class_name: 'MatchLog'
    has_many :players, through: :player_records

    accepts_nested_attributes_for :player_records,
                                  allow_destroy: true,
                                  reject_if: :invalid_record?
    accepts_nested_attributes_for :logs,
                                  allow_destroy: true,
                                  reject_if: :invalid_log?

    scope :with_motm, lambda {
      joins(
        'LEFT JOIN my_fifa_players ON ' \
        'my_fifa_matches.motm_id = my_fifa_players.id'
      ).select('my_fifa_matches.*, my_fifa_players.name AS motm_name')
    }

    ############################
    #  INITIALIZATION METHODS  #
    ############################
    def build_records(formation)
      (1..11).each do |n|
        player_records.build(pos: formation.public_send("pos_#{n}"))
      end
    end

    ########################
    #  ASSIGNMENT METHODS  #
    ########################

    # score_f: GF (PF)
    # score_a: GA (PA)
    # score: GF (PF) - GA (PA)
    %w[f a].each do |type|
      define_method "score_#{type}" do
        goals = send("score_g#{type}")
        penalties = send("penalties_g#{type}")
        "#{goals}#{penalties.present? ? " (#{penalties})" : ''}"
      end

      define_method "score_#{type}=" do |val|
        return if val.blank?
        goals, penalties = val.match(/^(\d+)(?: \((\d+)\))*$/i).captures
        write_attribute :"score_g#{type}", goals
        write_attribute :"penalties_g#{type}", penalties
      end
    end

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :competition,
              presence: { message: 'Competition can\'t be blank.' }
    validates :opponent,
              presence: { message: 'Opponent Team can\'t be blank.' }
    validates :date_played,
              presence: { message: 'Date Played can\'t be blank.' }
    validates :score_gf,
              presence: { message: 'Score can\'t be blank.' }
    validates :score_ga,
              presence: {
                if: -> { score_gf.present? },
                message: 'Score can\'t be blank.'
              }
    validate :unique_players?

    def unique_players?
      player_ids = all_records.map(&:player_ids).uniq.compact
      return unless player_ids.any? { |id| player_ids.count(id) > 1 }
      errors.add(:base, 'One Player has been selected at least twice.')
    end

    def invalid_record?(attributed)
      attributed['pos'].blank?
    end

    def invalid_log?(attributed)
      %w[event player1_id minute].any? { |att| attributed[att].blank? }
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_save :update_current_date
    after_save :save_external_match_data
    after_commit :set_records_match_data

    def set_records_match_data
      match_logs = logs.group_by(&:event)
      %w[Goal Booking Injury].each do |event|
        match_logs[event] ||= []
      end

      traverse_records(lambda { |record|
        record.set_match_data(self, match_logs)
        return unless date_played == team.current_date
        record.create_event_if_injured
      })
    end

    def update_current_date
      return unless date_played > team.current_date
      team.update_column(:current_date, date_played)
    end

    def save_external_match_data
      return if team.teams_played.include? opponent
      team.teams_played << opponent
      team.save
    end

    #####################
    #  MUTATOR METHODS  #
    #####################
    def traverse_records(action_method)
      player_records.each do |record|
        current_record = record
        until current_record.nil? || current_record.destroyed?
          action_method.call(current_record)
          current_record = current_record.sub_record
        end
      end
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def player_ids
      player_records.inject([]) { |ids, record| ids + record.player_ids }
    end

    # rubocop:disable all
    def epoch() time_to_s(date_played, '%s') end
    def timestamp() time_to_s(date_played) end

    def score() "#{score_f} - #{score_a}" end
    def win?()  score_gf > score_ga end
    def draw?() score_gf == score_ga end
    def loss?() score_gf < score_ga end
    # rubocop:enable all

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
