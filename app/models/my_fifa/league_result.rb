module MyFifa
  class LeagueResult < Base
    belongs_to :league, inverse_of: :results

    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def losses
        (self.league.num_teams - 1) * self.league.matches_per_fixture
      end

      def goal_diff
        self.goals_for - self.goals_against
      end

      def points
        3 * self.wins + self.draws
      end

  end
end
