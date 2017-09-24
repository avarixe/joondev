module MyFifa
  class Season < Base
    self.table_name = 'my_fifa_seasons'
    default_scope { order(id: :asc)}

    belongs_to :team
    belongs_to :captain, class_name: 'Player'

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
      validates :start_club_worth, presence: { message: "Club Worth (Start of Season) cannot be blank." }
      validates :transfer_budget,  presence: { message: "Transfer Budget cannot be blank." }
      validates :wage_budget,      presence: { message: "Wage Budget cannot be blank." }
      validates :captain_id,       presence: { message: "The Team must have a Captain for the Season." }

    ######################
    #  CALLBACK METHODS  #
    ######################

    ######################
    #  MUTATORS METHODS  #
    ######################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def title
        "#{start_date.strftime('%Y')} - #{end_date.strftime('%Y')} Season"
      end
  end
end
