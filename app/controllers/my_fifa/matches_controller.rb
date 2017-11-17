require_dependency 'my_fifa/application_controller'

module MyFifa
  # :nodoc:
  class MatchesController < ApplicationController
    before_action :set_current_team
    before_action :set_match, only: %i[show edit update destroy]
    before_action :team_is_playable?
    include MatchesHelper

    # GET /players
    def index
      respond_to do |format|
        format.html { @title = 'Matches' }
        format.json do
          @matches = @team.matches
          filter_matches
          render json: {
            data: @matches.with_motm.reverse
          }.to_json(methods: %i[result score epoch timestamp])
        end
      end
    end

    # GET /players/1
    def show
      @records = @match.player_records.includes(:player, :sub_record)
      if @match.home?
        @title = "#{@team.team_name} v #{@match.opponent}"
        @score = "#{@match.score_f} - #{@match.score_a}"
      else
        @title = "#{@match.opponent} v #{@team.team_name}"
        @score = "#{@match.score_a} - #{@match.score_f}"
      end
      render_html_json('matches/show')
    end

    # GET /players/new
    def new
      @title = 'New Match'
      @match = Match.new(date_played: @team.current_date)

      @match.build_records(current_user.default_formation)
      @season = @team.current_season
      @grouped_players = Player.grouped_by_pos(@season.players.available)

      render_html_json('matches/_form')
    end

    # GET /players/1/edit
    def edit
      @title = 'Edit Match'
      @season = @match.season
      @grouped_players = Player.grouped_by_pos(@season.players)

      render_html_json('matches/_form')
    end

    # POST /players
    def create
      @match = Match.new(match_params)
      @match.season_id = @team.current_season.id

      respond_to do |format|
        format.js do
          unless @team.matches << @match
            render 'shared/errors', locals: { object: @match }
          end
        end
      end
    end

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.js do
          unless @match.update(match_params)
            render 'shared/errors', locals: { object: @match }
          end
        end
      end
    end

    def check_log
      log = MatchLog.new(params[:log].permit!)
      if log.valid?
        render json: log.to_json(methods: %i[icon message])
      else
        render json: nil
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match
               .includes(
                 player_records: [:sub_record],
                 logs: %i[player1 player2]
               )
               .with_motm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def match_params
      params[:match].permit!
    end
  end
end
