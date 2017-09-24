require_dependency "my_fifa/application_controller"

module MyFifa
  class SeasonsController < ApplicationController
    before_action :set_season, only: [:show, :edit, :update]
    before_action :set_current_team

    # GET /players
    def index
      @title = "Seasons"
      @seasons = @team.seasons
    end

    # GET /players/1
    def show
      @title = @season.title
    end

    # GET /players/new
    def new
      @title = "New Season"
      @season = @team.seasons.new(start_date: @team.current_date, end_date: @team.current_date + 1.year)
    end

    # GET /players/1/edit
    def edit
      @title = @season.title
    end

    # POST /players
    def create
      @season = Season.new(season_params)

      if @team.seasons << @season
        redirect_to @season
      else
        respond_to do |format|
          format.js { render 'my_fifa/shared/errors', locals: { object: @season } }
        end
      end
    end

    # PATCH/PUT /players/1
    def update
      if @season.update(season_params)
        redirect_to @season
      else
        respond_to do |format|
          format.js {
            render 'my_fifa/shared/errors', locals: { object: @season }
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