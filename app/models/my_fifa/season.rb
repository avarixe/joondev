module MyFifa
  class Season < Base
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

    ######################
    #  CALLBACK METHODS  #
    ######################

    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def title
        "#{start_date.strftime('%Y')} - #{end_date.strftime('%Y')} Season"
      end
  end
end
