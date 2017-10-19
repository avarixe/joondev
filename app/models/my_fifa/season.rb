module MyFifa
  class Season < Base
    default_scope { order(id: :asc)}

    belongs_to :team
    belongs_to :captain, class_name: 'Player'

    has_many :competitions

    has_many :player_seasons, dependent: :delete_all
    has_many :players, through: :player_seasons

    ############################
    #  INITIALIZATION METHODS  #
    ############################
    
    ########################
    #  ASSIGNMENT METHODS  #
    ########################

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :start_date,       presence: { message: "Start Date cannot be blank." }
      validates :end_date,         presence: { message: "End Date cannot be blank." }

    ######################
    #  CALLBACK METHODS  #
    ######################

    #####################
    #  MUTATOR METHODS  #
    #####################
      def build_next_season
        new_season = self.dup
        new_season.start_date       = self.end_date
        new_season.end_date         = self.end_date + 1.year
        new_season.start_club_worth = self.end_club_worth
        new_season.end_club_worth   = nil
        new_season.save

        self.player_seasons.includes(:player).each do |player_season|
          if player_season.player.active?
            new_player_season = player_season.dup
            new_player_season.season_id = new_season.id
            new_player_season.age += 1
            new_player_season.save
          end
        end

        return new_season
      end

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def current?
        self.end_date > self.team.current_date
      end
    
      def yearspan
        "#{self.start_date.strftime('%Y')} - #{self.end_date.strftime('%Y')}"
      end

      def title
        "#{self.yearspan} Season"
      end
      
      def competition_options
        self.competitions.map(&:title)
      end
  end
end
