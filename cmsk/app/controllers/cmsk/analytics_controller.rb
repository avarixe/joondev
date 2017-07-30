require_dependency "cmsk/application_controller"

module Cmsk
  class AnalyticsController < ApplicationController
    before_action :set_current_team
    before_action :set_records
    
    def index
      respond_to do |format|
        format.html {
          @title = "#{@team.team_name} - Analytics"
        }
        format.json {
          filter_records
          # set_totals

          @players = Player.with_stats(@games.map(&:id))
            .where(id: @records.map(&:player_id).uniq)

          render json: {
            data: @players
          }.to_json
        }
      end
    end
      
    private
      def set_records
        @records = @team.player_records
      end
    
      def filter_records
        query = {
          strings: [],
          args: []
        }

        if params[:season].present?
          start_date = Date.new(params[:season].to_i, 7, 1)
          end_date = Date.new(params[:season].to_i+1, 6, 30)

          query[:strings] << 'date_played BETWEEN ? AND ?'
          query[:args] += [start_date, end_date]
        end

        if params[:competition].present?
          query[:strings] << 'competition = ?'
          query[:args] << params[:competition]
        end

        if query[:strings].any?
          @games = Game.where(query[:strings].join(' AND '), *query[:args])
          @records = @records.where(game_id: @games.map(&:id))
        else
          @games = []
        end
      end
  end
end
