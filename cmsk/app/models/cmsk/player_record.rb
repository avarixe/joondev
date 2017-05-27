module Cmsk
  class PlayerRecord < Base
    belongs_to :team
    belongs_to :game
    belongs_to :player

    validates_presence_of :player_id, :rating, :pos
  end
end
