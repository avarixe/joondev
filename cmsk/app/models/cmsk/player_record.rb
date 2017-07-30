module Cmsk
  class PlayerRecord < Base
    belongs_to :team
    belongs_to :game
    belongs_to :player

    scope :with_game_data, -> {
      joins('LEFT JOIN cmsk_games ON cmsk_player_records.game_id = cmsk_games.id')
        .select('cmsk_player_records.*, ' + [
          # 'opponent',
          # 'competition',
          # 'score_gf',
          'score_ga',
          # 'penalties_gf',
          # 'penalties_ga',
          # 'date_played'
        ].map{ |f| "cmsk_games.#{f} AS #{f}"}.join(', ') )
    }

    scope :motm, -> {
      joins('LEFT JOIN cmsk_players ON cmsk_player_records.player_id = cmsk_players.id')
        .select()
    }


    validates_presence_of :player_id, :rating, :pos
  end
end
