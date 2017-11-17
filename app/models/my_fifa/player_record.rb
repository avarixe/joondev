# == Schema Information
#
# Table name: my_fifa_player_records
#
#  id           :integer          not null, primary key
#  team_id      :integer
#  match_id     :integer
#  player_id    :integer
#  rating       :integer
#  goals        :integer
#  assists      :integer
#  pos          :string(10)
#  cs           :boolean
#  record_id    :integer
#  yellow_cards :integer          default(0)
#  red_cards    :integer          default(0)
#  injury       :string
#

module MyFifa
  # Player Performance per Match
  class PlayerRecord < Base
    default_scope { order(id: :asc) }

    belongs_to :team
    belongs_to :match
    belongs_to :player
    belongs_to :record,
               class_name: 'PlayerRecord',
               inverse_of: :sub_record
    has_one :sub_record,
            class_name: 'PlayerRecord',
            foreign_key: :record_id,
            inverse_of: :record
    accepts_nested_attributes_for :sub_record,
                                  allow_destroy: true,
                                  reject_if: :invalid_record?

    scope :with_player, lambda {
      joins('LEFT JOIN my_fifa_players ON' \
            'my_fifa_player_records.player_id = my_fifa_players.id')
        .select([
          'my_fifa_player_records.*',
          'my_fifa_players.name AS player_name'
        ].join(', '))
    }

    scope :exclusively, ->(ids) { where(id: ids) }

    ###################
    #  CLASS METHODS  #
    ###################

    # Calculates sums using ActiveRecord (efficient for single Player view)
    def num_goals
      where.not(goals: nil).select(:goals).map(&:goals).sum
    end

    def num_assists
      where.not(assists: nil).select(:assists).map(&:assists).sum
    end

    def num_cs
      select(:cs).map(&:cs_to_i).sum
    end

    # Calculates sums from given array of Records
    def arr_num_goals(arr)
      arr.map(&:goals).compact.sum
    end

    def arr_num_assists(arr)
      arr.map(&:assists).compact.sum
    end

    def arr_rank(arr)
      arr.length +
        (arr.map(&:rating).sum / arr.length.to_f) +
        2 * arr_num_goals(arr) +
        arr_num_assists(arr)
    end

    ########################
    #  VALIDATION METHODS  #
    ########################
    validate :player_selected?
    validate :rating_selected?, if: -> { player_id.present? }

    def invalid_record?(attribute)
      attribute[:pos].blank?
    end

    def player_selected?
      return unless player_id.blank?
      errors.add(:player_id, "No Player has been assigned as #{pos}")
    end

    def rating_selected?
      return unless rating.blank?
      errors.add(:rating, "#{player.name}: Rating cannot be blank.")
    end

    #####################
    #  MUTATOR METHODS  #
    #####################
    def set_match_data(match, match_logs)
      update_columns(
        match_id:     match.id,
        team_id:      match.team_id,
        cs:           match.score_ga.zero?,
        goals:        MatchLog.count_goals(match_logs, self),
        assists:      MatchLog.count_assists(match_logs, self),
        yellow_cards: MatchLog.count_ycards(match_logs, self),
        red_cards:    MatchLog.count_rcards(match_logs, self),
        injury:       MatchLog.get_injury(match_logs, self)
      )
    end

    def create_event_if_injured
      return unless injury.present? && !player.injured?
      player.toggle_injury(match.date_played, '')
    end

    def player_ids
      ids = [player_id]
      ids << sub_record.player_ids if sub_record.present?
      ids
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def motm?
      player_id == match.motm_id
    end

    def rating_color
      RATING_COLORS[(rating / 5.0).round * 5]
    end

    def cs_to_i
      cs ? 1 : 0
    end
  end
end
