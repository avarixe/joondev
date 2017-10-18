module MyFifa
  class GroupResult < Base
    belongs_to :competition, inverse_of: :results

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_save :save_team_name
      
      def save_team_name
        team = self.competition.team
        unless self.team_name.blank? || team.teams_played.include? self.team_name || self.team_name == team.team_name
          team.teams_played << self.team_name
          team.save
        end
      end

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def losses
        num_fixtures = self.group.present? ?
          self.competition.num_teams / self.competition.num_groups - 1 :
          self.competition.num_teams - 1
        num_fixtures * self.competition.matches_per_fixture - self.wins - self.draws
      end

      def goal_diff
        self.goals_for - self.goals_against
      end

      def points
        3 * self.wins + self.draws
      end

  end
end
