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
        num_rounds = 1
        cup_fixtures = self.fixtures.to_a
        fixture_rounds = []
        until 1 << num_rounds > self.num_teams
          num_fixtures = 1 << num_rounds

          fixture_rounds << {
            name: ROUND_NAMES[num_fixtures] || "Round of #{num_fixtures}",
            fixtures: cup_fixtures.pop(1 << fixture_rounds.length)
          }
          num_rounds += 1
        end

        return fixture_rounds
      end

  end
end