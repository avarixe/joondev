module MyFifa
  # :nodoc:
  class AnalyticsController < ApplicationController
    before_action :set_current_team
    before_action :set_player_with_records, only: %i[records recent_form]
    before_action :set_player_with_seasons, only: %i[player_values player_ovr]
    include AnalyticsHelper

    def players
      @title = 'Analyze Players'
      @grouped_players = Player.grouped_by_pos(@team.players)
    end

    def stats
    end

    def charts
      @players = Player
                 .includes(records: [:match], player_seasons: [])
                 .where(id: params[:players].split(','))
      @seasons = @team.seasons
      @recent_matches = Match.includes(:player_records).last(10)
      set_player_data
      render_html_json('analytics/charts')
    end
  end
end
