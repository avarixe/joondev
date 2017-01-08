module Cmsk
  class Team < Cmsk::Base
    has_many :players
    has_many :squads
    has_many :games
    has_many :player_records
    
    validates_presence_of :team_name
    validates_presence_of :competitions
    
    def competition_options
      self.competitions.split(',').map{ |x| x.strip }
    end
    
    def sorted_players
      self.players.active.sort_by{ |p| Cmsk::Player.positions.index(p.pos) }
    end
  end
end
