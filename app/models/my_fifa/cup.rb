module MyFifa
  class Cup < Competition
    
    ########################
    #  VALIDATION METHODS  #
    ########################    
      validate :valid_number_of_teams
      
      def valid_number_of_teams
        unless multiple_of_two? self.num_teams
          errors.add(:base, "Number of Teams in a Cup must be a multiple of 2.")
        end
      end
    
    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :build_fixtures
      
      def build_fixtures
        (self.num_teams - 1).times do
          self.fixtures.create
        end
      end

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def rounds
        super(self.num_teams)
      end

  end
end