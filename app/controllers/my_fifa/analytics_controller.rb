require_dependency "my_fifa/application_controller"

module MyFifa
  class AnalyticsController < ApplicationController
    before_action :set_current_team
    
    def players
      respond_to do |format|
        format.html {
          @title = "Analytics"
        }
        format.json {
          @records = @team.player_records
          filter_records

          @players = Player.with_stats(@matches.map(&:id))
            .where(id: @records.map(&:player_id).uniq)

          render json: {
            data: @players
          }.to_json
        }
      end
    end
      
    private
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
          @matches = Match.where(query[:strings].join(' AND '), *query[:args])
          @records = @records.where(match_id: @matches.map(&:id))
        else
          @matches = []
        end
      end
  end
end
