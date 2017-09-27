module MyFifa
  class Team < Base
    default_scope { order(id: :asc)}

    belongs_to :user
    has_many :seasons
    has_many :players
    has_many :squads
    has_many :matches
    has_many :player_records
    
    serialize :competitions, Array

    ############################
    #  INITIALIZATION METHODS  #
    ############################
    

    ########################
    #  ASSIGNMENT METHODS  #
    ########################
      def competitions=(val)
        write_attribute :competitions, (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
      end

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :team_name, presence: { message: "Team Name can't be blank." }
      validates :current_date, presence: { message: "Start Date can't be blank." }
      validates_each :competitions do |record, attr, value|
        record.errors.add(:competitions, "Please supply at least one Competition.") if value.empty?
      end

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :create_first_season

      def create_first_season
        self.seasons.create(
          start_date: self.current_date,
          end_date:   self.current_date + 1.year
        )
      end

    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def playable?
        self.players.count >= 11
      end

      def current_season
        self.seasons.last
      end

      def competition_options(delimiter)
        competitions.join(delimiter) rescue ''
      end

      def recorded_seasons
        return [] if matches.empty?

        start_year = matches.first.date_played.strftime('%Y').to_i
        start_year -= 1 if matches.first.date_played < Date.new(start_year, 7, 1)
        
        latest_year = matches.last.date_played.strftime('%Y').to_i
        latest_year -= 1 if matches.last.date_played < Date.new(latest_year, 7, 1)
        
        (start_year..latest_year).each.map do |i|
          ["#{i} - #{i+1}", i]
        end
      end
      
      def recorded_competitions
        matches.map(&:competition).uniq
      end
      
      def sorted_players(no_injured = false)
        active_players = players.sorted.active
        no_injured ? active_players.uninjured : active_players
      end

      def grouped_players(options = {})
        sorted_players(options[:no_injured])
          .group_by(&:pos)
          .map{ |pos, players|
            [ pos, players.map{ |player| [(options[:abbrev] ? player.shorthand_name : player.name), player.id] }]
          }
      end
  end
end
