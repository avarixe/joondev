require_dependency "cmsk/application_controller"

module Cmsk
  class SeasonsController < ApplicationController
    before_action :set_season, only: [:show, :edit, :update, :get_fixtures]
    before_action :set_current_team

    # GET /seasons
    def index
      @page = "Seasons"
      @seasons = Season.all
    end

    # GET /seasons/1
    def show
      @page = "#{@season.title} #{@season.league}"
    end

    # GET /seasons/new
    def new
      @page = "New Season"
      @season = @team.seasons.new
    end

    # GET /seasons/1/edit
    def edit
      @page = "Edit Season"
    end

    # POST /seasons
    def create
      @season = @team.seasons.build(season_params)

      if @season.save
        redirect_to @season, notice: 'Season was successfully created.'
      else
       render :new
      end
    end

    # PATCH/PUT /seasons/1
    def update
      if @season.update(season_params)
        redirect_to @season, notice: 'Season was successfully updated.'
      else
        render :edit
      end
    end

    def get_fixtures
      respond_to do |format|
        format.json {
          render json: {
            data: @season.fixtures.with_game.as_json({ methods: [
              :home_score,
              :away_score,
              :date_played_string,
              :season_incomplete?
            ]})
          }
        }.to_json
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
