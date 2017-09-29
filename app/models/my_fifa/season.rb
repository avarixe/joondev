module MyFifa
  class Season < Base
    default_scope { order(id: :asc)}

    belongs_to :team
    belongs_to :captain, class_name: 'Player'

    has_many :player_seasons, dependent: :delete_all
    has_many :players, through: :player_seasons

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
      validates :start_date,       presence: { message: "Start Date cannot be blank." }
      validates :end_date,         presence: { message: "End Date cannot be blank." }

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :create_player_seasons
      
      def create_player_seasons
        self.team.sorted_players.each do |player|
          self.player_seasons.create(
            player_id: player.id,
            jersey_no: player.current_jersey_no,
            ovr:       player.current_ovr,
            value:     player.current_value,
            age:       player.current_age + 1
          )
        end
      end

    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def current?
        self.end_date > self.team.current_date
      end
    
      def title
        "#{start_date.strftime('%Y')} - #{end_date.strftime('%Y')} Season"
      end
      
      def competition_options(delimiter)
        competitions.join(delimiter) rescue ''
      end
  end
end
