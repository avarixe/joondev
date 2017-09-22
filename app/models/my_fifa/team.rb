module MyFifa
  class Team < Base
    self.table_name = 'my_fifa_teams'
    default_scope { order(id: :asc)}

    belongs_to :user
    has_many :players
    has_many :squads
    has_many :fixtures
    has_many :player_records
    
    serialize :competitions, Array

    validates :team_name, presence: { message: "Team Name can't be blank." }
    validates_each :competitions do |record, attr, value|
      record.errors.add(:competitions, "Please supply at least one Competition.") if value.empty?
    end

    def competitions=(val)
      write_attribute :competitions, (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
    end
   
    def competition_options(delimiter)
      competitions.join(delimiter) rescue ''
    end

    def recorded_seasons
      start_year = fixtures.first.date_played.strftime('%Y').to_i
      start_year -= 1 if fixtures.first.date_played < Date.new(start_year, 7, 1)
      
      latest_year = fixtures.last.date_played.strftime('%Y').to_i
      latest_year -= 1 if fixtures.last.date_played < Date.new(latest_year, 7, 1)
      
      (start_year..latest_year).each.map do |i|
        ["#{i} - #{i+1}", i]
      end
    end
    
    def recorded_competitions
      fixtures.map(&:competition).uniq
    end
    
    def sorted_players
      players.sorted.active
    end

    def grouped_players(options = {})
      sorted_players
        .group_by(&:pos)
        .map{ |pos, players|
          [ pos, players.map{ |player| [(options[:abbrev] ? player.shorthand_name : player.name), player.id] }]
        }
    end
  end
end
