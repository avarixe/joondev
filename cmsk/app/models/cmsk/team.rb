module Cmsk
  class Team < Base
    default_scope { order(id: :asc)}

    has_many :players
    has_many :squads
    has_many :leagues
    has_many :stages
    has_many :fixtures
    has_many :seasons
    has_many :games
    has_many :player_records
    
    validates_presence_of :team_name
    
    serialize :competitions

    def competitions=(val)
      write_attribute :competitions, (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
    end
   
    def competition_options(delimiter)
      competitions.join(delimiter) rescue ''
    end

    def recorded_seasons
      start_year = games.first.date_played.strftime('%Y').to_i
      start_year -= 1 if games.first.date_played < Date.new(start_year, 7, 1)
      
      latest_year = games.last.date_played.strftime('%Y').to_i
      latest_year -= 1 if games.last.date_played < Date.new(latest_year, 7, 1)
      
      (start_year..latest_year).each.map do |i|
        ["#{i} - #{i+1}", i]
      end
    end
    
    def recorded_competitions
      games.map(&:competition).uniq
    end
    
    def sorted_players
      positions = players.active
    end
  end
end
