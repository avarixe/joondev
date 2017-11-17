# == Schema Information
#
# Table name: my_fifa_competitions
#
#  id                  :integer          not null, primary key
#  type                :string
#  team_id             :integer
#  season_id           :integer
#  title               :string
#  champion            :string
#  num_teams           :integer          default(16)
#  matches_per_fixture :integer          default(1)
#  num_groups          :integer
#  num_advances        :integer
#

module MyFifa
  # Round-robin Competition
  class League < Competition
    ######################
    #  CALLBACK METHODS  #
    ######################
    after_create :build_results

    def build_results
      num_teams.times do
        results.create
      end
    end
  end
end
