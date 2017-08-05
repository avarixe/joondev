module Cmsk
  class Team < Base
    default_scope { order(id: :asc)}

    has_many :players
    has_many :squads
    has_many :competitions
    has_many :stages
    has_many :fixtures
    has_many :games
    has_many :player_records
    
    validates_presence_of :team_name
    
    def season_options
      start_year = games.first.date_played.strftime('%Y').to_i
      start_year -= 1 if games.first.date_played < Date.new(start_year, 7, 1)
      
      latest_year = games.last.date_played.strftime('%Y').to_i
      latest_year -= 1 if games.last.date_played < Date.new(latest_year, 7, 1)
      
      (start_year..latest_year).each.map do |i|
        ["#{i} - #{i+1}", i]
      end
    end
    
    def competition_options
      competitions_names.split(',').map{ |x| x.strip }
    end
    
    def recorded_competitions
      games.map(&:competition).uniq
    end
    
    def sorted_players
      positions = players.active
    end
  end
end
