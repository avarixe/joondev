module MyFifa
  class Competition < Base
    default_scope { 
      order(
        "CASE WHEN type = '#{League.sti_name}' THEN 1 WHEN type = '#{Cup.sti_name}' THEN 2 ELSE 3 END",
        id: :asc
      )
    }

    belongs_to :team
    belongs_to :season
    includes ApplicationHelper

    has_many :results, class_name: 'GroupResult', inverse_of: :competition
    accepts_nested_attributes_for :results

    has_many :fixtures
    accepts_nested_attributes_for :fixtures

    ROUND_NAMES = {
      2 => 'Final',
      4 => 'Semi Finals',
      8 => 'Quarter Finals',
    }

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :title,     presence: { message: "Competition must have a Title." }
      validates :type,      presence: { message: "Type must be specified." }
      validates :num_teams, numericality: { greater_than: 1, message: "Number of Teams must be greater than 1." }
      validate  :unique_title_per_season?, on: :create
      validate  :valid_type_chosen?

      def unique_title_per_season?
        if self.title.present? && self.season.competition_options.include?(self.title)
          errors.add(:title, "Competition has already been added for this Season.")
        end
      end

      def valid_type_chosen?
        if self.type.present?
          errors.add(:type, "Selected Type is Invalid.") unless Object.const_defined?(self.type)
        end
      end

    ######################
    #  CALLBACK METHODS  #
    ######################

    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
    
      def rounds(num_participants)
        num_rounds = 1
        cup_fixtures = self.fixtures.to_a
        fixture_rounds = []
        until 1 << num_rounds > num_participants
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
