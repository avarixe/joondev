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
  # Base Class for League, Cup, Tournament
  class Competition < Base
    default_scope do
      order(
        'CASE ' \
        'WHEN type = \'MyFifa::League\' THEN 1 ' \
        'WHEN type = \'MyFifa::Cup\' THEN 2 ' \
        'ELSE 3 ' \
        'END',
        id: :asc
      )
    end

    belongs_to :team
    belongs_to :season
    includes ApplicationHelper

    has_many :results, class_name: 'GroupResult', inverse_of: :competition
    accepts_nested_attributes_for :results

    has_many :fixtures
    accepts_nested_attributes_for :fixtures

    ROUND_NAMES = {
      1 => 'Final',
      2 => 'Semi Finals',
      4 => 'Quarter Finals'
    }.freeze

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :title,
              presence: { message: 'Competition must have a Title.' }
    validates :type,
              presence: { message: 'Type must be specified.' }
    validates :num_teams,
              numericality: {
                greater_than: 1,
                message: 'Number of Teams must be greater than 1.'
              }
    validate :unique_title_per_season?, on: :create
    validate :valid_type_chosen?

    def unique_title_per_season?
      return unless title.present? && season.competition_options.include?(title)
      errors.add(
        :title,
        'Competition has already been added for this Season.'
      )
    end

    def valid_type_chosen?
      return unless type.present? && !Object.const_defined?(type)
      errors.add(:type, 'Selected Type is Invalid.')
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def completed?
      results.all?(&:completed?) && fixtures.all?(&:completed?)
    end

    def matches
      season.matches.where(competition: title)
    end

    def rounds
      cup_fixtures = fixtures.to_a
      fixture_rounds = []
      until cup_fixtures.empty?
        num_fixtures = cup_fixtures.length / 2 + 1
        fixture_rounds << {
          name: ROUND_NAMES[num_fixtures] || "Round of #{num_fixtures * 2}",
          fixtures: cup_fixtures.shift(num_fixtures)
        }
      end
      fixture_rounds
    end
  end
end
