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
          'my_fifa_players.name as player_name'
        ].join(', ') )
    }

    scope :exclusively, -> (ids) {
      where(id: ids)
    }

    ############################
    #  INITIALIZATION METHODS  #
    ############################
    

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
      after_save :create_event_if_injured

      def set_match_id
        update_columns(
          match_id: record.match_id,
          team_id: record.team_id,
          cs: record.cs,
        ) if match_id.nil?
      end

      def create_event_if_injured
        if self.injury.present? && !self.player.injured?
          self.player.toggle_injury(self.player.team.current_date, self.injury)
        end
      end

      def set_sub_match_data
        if self.sub_record.present?
          self.sub_record.update_columns(
            team_id: self.team_id,
            cs:      self.cs,
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
  end
end
