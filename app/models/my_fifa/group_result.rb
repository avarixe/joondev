# == Schema Information
#
# Table name: my_fifa_group_results
#
#  id             :integer          not null, primary key
#  competition_id :integer
#  team_name      :string
#  wins           :integer          default(0)
#  draws          :integer          default(0)
#  goals_for      :integer          default(0)
#  goals_against  :integer          default(0)
#  group          :string
#

module MyFifa
  # League Table row
  class GroupResult < Base
    belongs_to :competition, inverse_of: :results

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_save :save_team_name

    def save_team_name
      team = competition.team
      return if team_name.blank? ||
                team.teams_played.include?(team_name) ||
                team_name == team.team_name
      team.teams_played << team_name
      team.save
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def completed?
      [
        team_name,
        wins,
        draws,
        goals_for,
        goals_against
      ].all?(&:present?)
    end

    def losses
      num_fixtures = competition.num_teams
      num_fixtures /= competition.num_groups if group.present?
      num_fixtures -= 1
      num_fixtures * competition.matches_per_fixture - wins - draws
    end

    def goal_diff
      goals_for - goals_against
    end

    def points
      3 * wins + draws
    end
  end
end
