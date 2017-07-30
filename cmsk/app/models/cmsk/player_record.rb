module Cmsk
  class PlayerRecord < Base
    belongs_to :team
    belongs_to :game
    belongs_to :player

    scope :with_player, -> {
      joins('LEFT JOIN cmsk_players ON cmsk_player_records.player_id = cmsk_players.id')
        .select([
          'cmsk_player_records.*',
          'cmsk_players.name as player_name'
        ].join(', ') )
    }

    scope :exclusively, -> (ids) {
      where(id: ids)
    }

    validates_presence_of :player_id, :rating, :pos
  end
end
