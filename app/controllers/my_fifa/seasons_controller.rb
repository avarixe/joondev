require_dependency "my_fifa/application_controller"

module MyFifa
  class SeasonsController < ApplicationController
    before_action :set_season, only: [:edit, :update]
    before_action :set_current_team

    # GET /players
    def index
      @title = "Seasons"
      @seasons = @team.seasons
    end

    # GET /players/1
    def show
      @season = Season.includes(player_seasons: [:player]).find(params[:id])
      @title = @season.title
      @matches = @team.matches.where(date_played: @season.start_date..@season.end_date)
    end

    # GET /players/1/edit
    def edit
      @title = @season.title
    end

    def create
      @season = @team.current_season.build_next_season
      redirect_to @season
    end

    # PATCH/PUT /players/1
    def update
      if @season.update(season_params)
        redirect_to @season
      else
        respond_to do |format|
          format.js {
            render 'shared/errors', locals: { object: @season }
          }
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_season
        @season = Season.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def season_params
        params[:season].permit!
      end
  end
end
