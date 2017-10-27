require_dependency "my_fifa/application_controller"

module MyFifa
  class SeasonsController < ApplicationController
    before_action :set_season, only: [:edit, :update]
    before_action :set_current_team
    include PlayerAnalytics

    # GET /players
    def index
      @title = "Seasons"
      @seasons = @team.seasons
    end

    # GET /players/1
    def show
      @season = Season.includes(player_seasons: [:player]).find(params[:id])
      @title = @season.title
      @matches = @season.matches
      @competitions = @season.competitions.includes(:fixtures, :group_results)

      # compile Individual Accolades
      season_players = Player.with_stats(@season.matches.map(&:id)).includes(:player_seasons, :contracts)
      @accolades = {
        top_rank:        season_players.sort_by(&:rank).last,
        top_goalscorer:  season_players.sort_by(&:goals).last,
        top_playmaker:   season_players.sort_by(&:assists).last,
        top_goalkeeper:  season_players.select{ |player| player.pos == 'GK' }.sort_by(&:rank).last,
        top_under_21:    season_players.select{ |player| player.age < 21 }.sort_by(&:rank).last,
        top_new_arrival: season_players.select{ |player| (@season.start_date..@season.end_date).cover? player.date_joined }.sort_by(&:rank).last
      }
    end

    def competitions
      @season = Season.includes(competitions: [:results, :fixtures]).find(params[:id])
      @title = "#{@season.title} - Competitions"
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

    def competitions_json
      competitions = params[:season].present? ?
        Season.find(params[:season]).competition_options :
        @team.recorded_competitions
      render json: competitions.map{ |comp| 
        { value: comp, name: comp }
      }.unshift({ value: '', name: 'All Competitions' }).to_json
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
