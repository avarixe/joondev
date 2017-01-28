require_dependency "cmsk/application_controller"

module Cmsk
  class AnalyticsController < ApplicationController
    before_action :set_current_team
    before_action :set_records
    
    def index
      set_totals
      set_index
    end
    
    def search
      if params[:season].present?
        start_date = Date.new(params[:season].to_i, 7, 1)
        end_date = Date.new(params[:season].to_i+1, 6, 30)

        puts start_date
        puts end_date
        
        @records = @records.select{ |rec| 
          (start_date..end_date).cover?(rec.game.date_played)
          
        }
      end
      @records = @records.select{ |rec| rec.game.competition == params[:competition] } if params[:competition].present?

      set_totals
      set_index
    end
    
    private
      def set_records
        @records = @team.player_records
      end
    
      def set_totals
        @totals = {}
        @records.each do |record|
          puts record.player.pos
          player_name = record.player.name
          @totals[player_name] ||= Hash.new(0)
          @totals[player_name][:pos] = record.player.pos
          @totals[player_name][:gp] += 1
          @totals[player_name][:rating] += record.rating
          @totals[player_name][:goals] += record.goals.to_i
          @totals[player_name][:assists] += record.assists.to_i
          @totals[player_name][:cs] += 1 if record.game.score_ga == 0
        end
      end
      
      def set_index
        @title = "#{@team.team_name} - Analytics"
        render :index
      end
  end
end
