module MyFifa
  class PlayerRecord < Base
    default_scope { order(id: :asc)}

    belongs_to :team
    belongs_to :match
    belongs_to :player
    
    belongs_to :record, class_name: 'PlayerRecord', inverse_of: :sub_record
    has_one :sub_record, class_name: 'PlayerRecord', foreign_key: :record_id, inverse_of: :record
    accepts_nested_attributes_for :sub_record, allow_destroy: true, reject_if: :invalid_record?

    scope :with_player, -> {
      joins('LEFT JOIN my_fifa_players ON my_fifa_player_records.player_id = my_fifa_players.id')
        .select([
          'my_fifa_player_records.*',
          'my_fifa_players.name AS player_name'
        ].join(', ') )
    }

    scope :exclusively, -> (ids) {
      where(id: ids)
    }

    ###################
    #  CLASS METHODS  #
    ###################

      # Calculates sums using ActiveRecord (efficient for single Player view)
      def self.num_goals()   self.where.not(goals: nil).select(:goals).map(&:goals).sum end
      def self.num_assists() self.where.not(assists: nil).select(:assists).map(&:assists).sum end
      def self.num_cs()      self.select(:cs).map(&:cs_to_i).sum end

      # Calculates sums from given array of Records
      def self.arr_num_goals(arr)   arr.map(&:goals).compact.sum end
      def self.arr_num_assists(arr) arr.map(&:assists).compact.sum end
      def self.arr_rank(arr)
        arr.length + 
        (arr.map(&:rating).sum / arr.length.to_f) + 
        2*self.arr_num_goals(arr) +
        self.arr_num_assists(arr)
      end


    ########################
    #  ASSIGNMENT METHODS  #
    ########################


    ########################
    #  VALIDATION METHODS  #
    ########################
      validate :player_selected?
      validate :rating_selected?, if: -> { player_id.present? }

      def invalid_record?(attribute)
        attribute[:pos].blank?
      end

      def player_selected?() errors.add(:player_id, "No Player has been assigned as #{pos}") if player_id.blank? end
      def rating_selected?() errors.add(:rating, "#{player.name}: Rating cannot be blank.") if rating.blank? end

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :set_match_id

      def set_match_id
        update_columns(
          match_id: record.match_id,
          team_id: record.team_id,
          cs: record.cs,
        ) if match_id.nil?
      end

      def create_event_if_injured
        if self.injury.present? && !self.player.injured?
          self.player.toggle_injury(self.match.date_played, "")
        end
      end

      def set_sub_match_data
        if self.sub_record.present? && !self.sub_record.destroyed?
          self.sub_record.update_columns(
            team_id: self.team_id,
            cs: self.cs
          )
          self.sub_record.set_sub_match_data
        end
      end

    #####################
    #  MUTATOR METHODS  #
    #####################
      def player_ids
        ids = [self.player_id]
        ids << self.sub_record.player_ids if self.sub_record.present?
      end

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def motm?
        player_id == self.match.motm_id
      end
      
      def rating_color
        RATING_COLORS[(self.rating / 5.0).round * 5]
      end

      # ANALYTICS HELPERS
      def cs_to_i() self.cs ? 1 : 0 end
  end
end
