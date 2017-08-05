module Cmsk
  class Stage < Base
    belongs_to :competition
    has_many :fixtures, dependent: :destroy

    CATEGORIES = [
      'Knockout',
      'League'
    ]

    serialize :opponents

    def opponents=(val)
      write_attribute :opponents, (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
    end

    after_save :generate_fixtures

    def generate_fixtures
      self.fixtures.destroy_all

      teams = [self.competition.team.team_name] + opponents
      new_fixtures = []
      set_teams = [] # For one only fixtures

      teams.each do |home|
        set_teams = [] if num_plays > 1
        set_teams << home

        (teams - set_teams).each do |away|
          new_fixtures << self.fixtures.new(team_id: team_id, home: home, away: away)
        end
      end


      Fixture.transaction do
        new_fixtures.map(&:save!)
      end
    end
  end
end
