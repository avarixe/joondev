module Cmsk
  class Team < Cmsk::Base
    has_many :players
    has_many :squads
    has_many :games
    has_many :player_records
    
    validates_presence_of :team_name
    validates_presence_of :competitions
    
    def season_options
      start_year = self.games.first.date_played.strftime('%Y').to_i
      start_year -= 1 if self.games.first.date_played < Date.new(start_year, 7, 1)
      
      latest_year = self.games.last.date_played.strftime('%Y').to_i
      latest_year -= 1 if self.games.last.date_played < Date.new(latest_year, 7, 1)
      
      
      (start_year..latest_year).each.map do |i|
        ["#{i} - #{i+1}", i]
      end
    end
    
    def competition_options
      self.competitions.split(',').map{ |x| x.strip }
    end
    
    def recorded_competitions
      self.games.map(&:competition).uniq
    end
    
    def sorted_players
      self.players.active.sort_by{ |p| Cmsk::Player.positions.index(p.pos) }
    end
  end
end
