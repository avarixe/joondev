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
  # Round-robin + Knockout Stage
  class Tournament < Competition
    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :num_groups,
              numericality: {
                greater_than: 0,
                message: 'Number of Groups must be greater than 0.'
              }
    validates :num_advances,
              numericality: {
                greater_than: 0,
                message: 'Teams in Knockout Stage must be greater than 0.'
              }
    validate :evenly_grouped?, if: proc { |t| t.num_teams && t.num_groups }
    validate :even_knockout_teams?, if: proc { t.num_advances }

    def evenly_grouped?
      return unless num_teams % num_groups != 0
      errors.add(:base, 'Teams do not evenly divide into Groups.')
    end

    def even_knockout_teams?
      return if multiple_of_two?(num_advances)
      errors.add(:base, 'Teams in Knockout Stage must be a multiple of 2.')
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_create :build_tournament

    def build_tournament
      # Create Group Records
      num_teams.times do |i|
        results.create(group: ('A'.ord + i % num_groups).chr)
      end

      # Create Fixtures
      (num_advances - 1).times do
        fixtures.create
      end
    end
  end
end
