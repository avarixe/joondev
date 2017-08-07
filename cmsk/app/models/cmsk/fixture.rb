module Cmsk
  class Fixture < Base
    belongs_to :team, inverse_of: :fixtures
    belongs_to :stage
    has_one :game

    scope :with_game, -> {
      joins(:team, 'LEFT JOIN cmsk_games ON cmsk_fixtures.id = cmsk_games.fixture_id')
        .select([
          'cmsk_fixtures.*', 
          '(CASE WHEN cmsk_games.fixture_id IS NULL THEN FALSE ELSE TRUE END) as game_exists',
          '(CASE WHEN cmsk_fixtures.home = cmsk_teams.team_name OR cmsk_fixtures.away = cmsk_teams.team_name THEN TRUE ELSE FALSE END) as user_team_playing'
        ].join(', '))
    }

    # RESULTS
    #   0 - Unplayed
    #   1 - Home Win
    #   2 - Draw
    #   3 - Away Win

    after_save :set_result

    def set_result
      update_column(
        :result,
        if goals_home.blank? || goals_away.blank?
          0
        elsif goals_home > goals_away
          1
        elsif goals_home < goals_away
          3
        elsif penalties_home.blank? || penalties_away.blank?
          2
        else
          penalties_home > penalties_away ? 1 : 3
        end
      )

      stage.set_status
    end

    def stage_incomplete?() stage.status == 0 end

    def home_score() "#{goals_home}#{" (#{penalties_home})" if penalties_home.present?}" end
    def away_score() "#{goals_away}#{" (#{penalties_away})" if penalties_away.present?}" end

    %w(home away).each do |side|
      define_method "#{side}_score=" do |val|
        goals, penalties = val.match(/^(\d+)(?: \((\d+)\))*$/i).captures
        write_attribute :"goals_#{side}", goals
        write_attribute :"penalties_#{side}", penalties
      end
    end

    def init_game
      game = self.build_game(
        team_id:     self.team_id,
        opponent:    self.team.team_name == home ? away : home,
        competition: self.stage.competition.title,
      )
    end
  end
end
