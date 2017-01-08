module Cmsk
  class PlayerRecord < Cmsk::Base
    belongs_to :team
    belongs_to :game
    belongs_to :player

    validates_presence_of :player_id, :rating, :pos
  end
end
