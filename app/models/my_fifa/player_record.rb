module MyFifa
  class PlayerRecord < Base
    self.table_name = 'my_fifa_player_records'
    default_scope { order(id: :asc)}

    belongs_to :team
    belongs_to :fixture
    belongs_to :player
    
    belongs_to :record, class_name: 'PlayerRecord'
    has_one :sub_record, class_name: 'PlayerRecord', foreign_key: :record_id
    accepts_nested_attributes_for :sub_record, allow_destroy: true, reject_if: :invalid_record?

    validate :player_selected?
    validate :rating_selected?, if: -> { player_id.present? }
    validate :ovr_selected?,    if: -> { player_id.present? }

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

    after_create :set_fixture_id
    def set_fixture_id
      puts 'in set_fixture_id'
      update_columns(
        fixture_id: record.fixture_id,
        team_id: record.team_id,
        cs: record.cs,
      ) if fixture_id.nil?
    end

    def invalid_record?(record)
      record[:pos].blank?
    end

    def player_ids
      ids = [self.player_id]
      ids << self.sub_record.player_ids if self.sub_record.present?
    end

    def player_selected?() errors.add(:player_id, "No Player has been assigned as #{pos}") if player_id.blank? end
    def rating_selected?() errors.add(:rating, "#{player.name}: Rating cannot be blank.") if rating.blank? end
    def ovr_selected?()    errors.add(:ovr, "#{player.name}: OVR cannot be blank.") if ovr.blank? end

    def motm?
      player_id == fixture.motm_id
    end
  end
end
