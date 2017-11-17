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
  # Knockout Competition
  class Cup < Competition
    ########################
    #  VALIDATION METHODS  #
    ########################
    validate :valid_number_of_teams

    def valid_number_of_teams
      return if multiple_of_two? num_teams
      errors.add(:base, 'Number of Teams in a Cup must be a multiple of 2.')
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_create :build_fixtures

    def build_fixtures
      (num_teams - 1).times do
        fixtures.create
      end
    end
  end
end
