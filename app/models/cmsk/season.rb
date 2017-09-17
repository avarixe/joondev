module Cmsk
  class Season < Base
    default_scope { order(id: :asc) }

    belongs_to :team
    has_many :fixtures, dependent: :destroy

    serialize :opponents
    validate :valid_number_of_opponents?

    def opponents=(val)
      write_attribute :opponents, (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
    end

    def valid_number_of_opponents?
      errors.add(:opponents, 'must contain at least 1 Team.') if opponents.length < 1
    end

    after_save :generate_fixtures

    def generate_fixtures
      if opponents_changed?
        self.fixtures.destroy_all

        new_fixtures = []
        set_teams = [] # For one only fixtures

        teams = [team.team_name] + opponents

        teams.each do |home|
          (teams - [home]).each do |away|
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
        num_teams = opponents.length + 1
        num_fixtures = num_teams * (num_teams - 1)

        if fixtures.where.not(result: 0).count == num_fixtures
          update_column(:status, 1)
        end
      end
    end
  end
end
