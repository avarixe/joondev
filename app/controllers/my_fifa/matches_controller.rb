require_dependency "my_fifa/application_controller"

module MyFifa
  class MatchesController < ApplicationController
    before_action :set_match, only: [:show, :edit, :update, :destroy]
    before_action :set_current_team
    before_action :team_is_playable?
    include MatchAnalytics

    # GET /players
    def index
      respond_to do |format|
        format.html {
          @title = "Match Archives"
        }
        format.json {
          @matches = @team.matches
          filter_matches
          render json: {
            data: @matches.with_motm.reverse.map{ |match|
              {
                id:          match.id,
                result:      match.result,
                opponent:    match.opponent,
                competition: match.competition,
                score:       match.score,
                motm:        match.motm_name,
                timestamp:   time_to_s(match.date_played, '%s'),
                date_played: time_to_s(match.date_played, '%b %e, %Y')
              }
            }
          }.to_json
        }
      end
    end

    # GET /players/1
    def show         
      respond_to do |format|
        @records = @match.player_records.includes(:player, :sub_record)
        @title = @match.home ?
          "#{@team.team_name} v #{@match.opponent}" :
          "#{@match.opponent} v #{@team.team_name}"
        @score = @match.home ? 
          "#{@match.score_f} - #{@match.score_a}" : 
          "#{@match.score_a} - #{@match.score_f}"

        format.html
        format.json {
          render json: render_to_string(template: "/my_fifa/matches/show.html", layout: false).to_json
        }
        format.xlsx {
          # Prepare Copy Table
          @data = { 
            ratings: [],
            goals: [],
            assists: []
          }

          all_records = @match.all_records
          player_ids = all_records.map(&:player_id)
          @team.sorted_players.each do |player|
            played = player_ids.include?(player.id)

            if played
              record = all_records.find_by(player_id: player.id)

              @data[:ratings] << record.rating
              @data[:goals]   << record.goals
              @data[:assists] << record.assists
            else
              @data[:ratings] << nil
              @data[:goals]   << nil
              @data[:assists] << nil
            end
          end
        }
      end
    end

    # GET /players/new
    def new
      @title = "New Match"
      @match = Match.new(date_played: @team.current_date)

      @match.build_records(current_user.default_formation)
      @grouped_players = @team.grouped_players(no_injured: true)

      respond_to do |format|
        format.html
        format.json {
          render json: render_to_string(template: "/my_fifa/matches/_form.html", layout: false).to_json
        }
      end
    end

    # GET /players/1/edit
    def edit
      @title = "Edit Match"
      @grouped_players = @team.grouped_players

      respond_to do |format|
        format.html
        format.json {
          render json: render_to_string(template: "/my_fifa/matches/_form.html", layout: false).to_json
        }
      end
    end

    # POST /players
    def create
      @match = Match.new(match_params)

      respond_to do |format|
        format.js {
          unless @team.matches << @match
            render 'shared/errors', locals: { object: @match }
          end
        }
      end
    end

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.js {
          unless @match.update(match_params)
            render 'shared/errors', locals: { object: @match }
          end
        }
      end
    end

    # DELETE /players/1
    def destroy
      @match.destroy
      redirect_to matches_url, notice: 'Match was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_match
        @match = Match.with_motm.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def match_params
        params[:match].permit!
      end
  end
end
