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

        games = Game.where('date_played BETWEEN ? AND ?', start_date, end_date)
        @records = @records.where(game_id: games.map(&:id))
      end

      if params[:competition].present?
        games = Game.where(competition: params[:competition])
        @records = @records.where(game_id: games.map(&:id))
      end

      set_totals
      set_index
    end
    
    private
      def set_records
        @records = @team.player_records
      end
    
      def set_totals
        @totals = {}

        Player.active.each do |player|
          records = @records.where(player_id: player.id)

          next if records.length == 0

          total_rating = sum(records.map(&:rating))
          avg_rating = total_rating > 0 ? total_rating / records.length : 0

          @totals[player.name] = {
            pos:     player.pos,
            gp:      records.length,
            rating:  avg_rating,
            goals:   sum(records.map(&:goals)),
            assists: sum(records.map(&:assists)),
            cs:      records.select{ |rec| rec.game.score_ga == 0 }.length
          }
        end

        puts @totals
      end
      
      def set_index
        @title = "#{@team.team_name} - Analytics"
        render :index
      end
  end
end
