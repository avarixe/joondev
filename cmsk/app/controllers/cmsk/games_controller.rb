require_dependency "cmsk/application_controller"

module Cmsk
  class GamesController < ApplicationController
    before_action :set_game, only: [:show, :edit, :update, :destroy]
    before_action :set_current_team

    # GET /players
    def index
      respond_to do |format|
        format.html {
          @page = "Game Archives"
        }
        format.json {
          @games = @team.games
          render json: {
            data: @games.with_motm.reverse.map{ |game|
              {
                id:          game.id,
                result:      game.result,
                opponent:    game.opponent,
                competition: game.competition,
                score:       game.score,
                motm:        game.motm_name,
                date_played: time_to_string(game.date_played, '%B %e, %Y')
              }
            }
          }.to_json
        }
      end
    end

    # GET /players/1
    def show         
      respond_to do |format|
        @records = @game.player_records.with_player

        format.html {
          @page = "Game Record"
        }
        format.xlsx {
          # Prepare Copy Table
          @data = { 
            ratings: [],
            goals: [],
            assists: []
          }
          player_ids = @records.map(&:player_id)
          @team.sorted_players.each do |player|
            played = player_ids.include?(player.id)

            if played
              record = @records.find_by(player_id: player.id)

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
      @page = "New Game"
      @last_played = @team.games.last.date_played unless @team.games.empty?
      @game = Game.new
      @game.build_records
      @sorted_players = @team.sorted_players
    end

    # GET /players/1/edit
    def edit
      @page = "Edit Game"
      @sorted_players = @team.sorted_players
    end

    # POST /players
    def create
      @game = Game.new(game_params)

      if @team.games.push @game
        redirect_to @game, notice: 'Game was successfully created.'
      else
        @page = "New Game"
        @sorted_players = @team.sorted_players
        render :new
      end
    end

    # PATCH/PUT /players/1
    def update
      if @game.update(game_params)
        redirect_to @game, notice: 'Game was successfully updated.'
      else
        @page = "Edit Game"
        @sorted_players = @team.sorted_players
        render :edit
      end
    end

    # DELETE /players/1
    def destroy
      @game.destroy
      redirect_to games_url, notice: 'Game was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_game
        @game = Game.with_motm.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def game_params
        params[:game].permit!
      end
  end
end
