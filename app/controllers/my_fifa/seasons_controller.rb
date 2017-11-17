require_dependency 'my_fifa/application_controller'

module MyFifa
  # :nodoc:
  class SeasonsController < ApplicationController
    before_action :set_season, only: %i[edit update]
    before_action :set_current_team
    include PlayersHelper
    include SeasonsHelper

    # GET /players
    def index
      @title = 'Seasons'
      @seasons = @team.seasons
    end

    # GET /players/1
    def show
      @season = Season.includes(player_seasons: [:player]).find(params[:id])
      @title = @season.title
      @matches = @season.matches
      @competitions = @season.competitions.includes(:fixtures, :group_results)

      # compile Individual Accolades
      return unless @matches.any?
      @season_players = Player
                        .with_stats(@matches.map(&:id))
                        .includes(:player_seasons, :contracts)
      set_accolades
    end

    def competitions
      @season = Season
                .includes(competitions: %i[results fixtures])
                .find(params[:id])
      @title = "#{@season.title} - Competitions"
    end

    # GET /players/1/edit
    def edit
      @title = @season.title
      @grouped_players = Player.grouped_by_pos(@season.players.available)
    end

    def create
      @season = @team.current_season.build_next_season
      @team.update(current_date: @season.start_date)
      redirect_to @season
    end

    # PATCH/PUT /players/1
    def update
      if @season.update(season_params)
        redirect_to @season
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @season } }
        end
      end
    end

    def competitions_json
      competitions =
        if params[:season].present?
          Season.find(params[:season]).competition_options
        else
          @team.recorded_competitions
        end
      render json: competitions
        .map { |comp| { value: comp, name: comp } }
        .unshift(value: '', name: 'All Competitions').to_json
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
