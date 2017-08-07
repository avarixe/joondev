module Cmsk
  class Stage < Base
    default_scope { order(id: :asc) }

    belongs_to :competition
    has_many :fixtures, dependent: :destroy

    CATEGORIES = [
      'Knockout',
      'League'
    ]

    serialize :opponents
    validate :valid_number_of_opponents?

    def opponents=(val)
      write_attribute :opponents, (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
    end

    def valid_number_of_opponents?
      if category == 'Knockout' && opponents.length.odd?
        errors.add(:opponents, 'must contain an even number of Teams for Knockout Stages.')
      elsif opponents.length < 2
        errors.add(:opponents, 'must contain at least 2 Teams.')
      end
    end

    after_save :generate_fixtures

    def generate_fixtures
      if opponents_changed?
        self.fixtures.destroy_all

        new_fixtures = []
        set_teams = [] # For one only fixtures

        opponents.each do |home|
          (opponents - [home]).each do |away|
            new_fixtures << self.fixtures.new(team_id: team_id, home: home, away: away)
          end
        end

        Fixture.transaction do
          new_fixtures.map(&:save!)
        end
      end
    end

    # STATUS: 
    #   0 - Incomplete
    #   1 - Complete

    def incomplete?() status == 0 end
    def complete?()   status == 1 end

    def set_status
      if status == 0
        num_teams = opponents.length
        num_fixtures = num_teams
        num_fixtures /= 2 if num_plays == 1
        num_fixtures *= num_teams - 1 if category == 'League'

        if fixtures.where.not(result: 0).count == num_fixtures
          self.fixtures.where(result: 0).destroy_all
          update_column(:status, 1)
        end
      end
    end
  end
end
