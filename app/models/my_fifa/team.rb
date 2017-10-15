module MyFifa
  class Team < Base
    default_scope { order(id: :asc)}

    belongs_to :user
    has_many :seasons, dependent: :destroy
    has_many :competitions, dependent: :destroy
    has_many :players, dependent: :destroy
    has_many :squads,  dependent: :delete_all
    has_many :matches, dependent: :delete_all
    has_many :player_records, dependent: :delete_all
    
    serialize :teams_played, Array

    ############################
    #  INITIALIZATION METHODS  #
    ############################
    
    ########################
    #  ASSIGNMENT METHODS  #
    ########################
      def teams_played=(val)
        write_attribute :teams_played, (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
      end

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :team_name, presence: { message: "Team Name can't be blank." }
      validates :current_date, presence: { message: "Start Date can't be blank." }

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :create_first_season

      def create_first_season
        new_player_seasons = []
        
        new_player_seasons << self.seasons.build(
          start_date: self.current_date,
          end_date:   self.current_date + 1.year
        )
        
        PlayerSeason.transaction do
          new_player_seasons.map(&:save)
        end
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
