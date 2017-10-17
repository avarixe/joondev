module MyFifa
  class GroupResult < Base
    belongs_to :competition, inverse_of: :results

    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def losses
        if self.group.present?
          0
        else
          (self.competition.num_teams - 1) * self.competition.matches_per_fixture - self.wins - self.draws
        end
      end

      def goal_diff
        self.goals_for - self.goals_against
      end

      def points
        3 * self.wins + self.draws
      end

  end
end
