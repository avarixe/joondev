require_dependency "cmsk/application_controller"

module Cmsk
  class GamesController < ApplicationController
    before_action :set_game, only: [:show, :edit, :update, :destroy]
    before_action :set_current_team

    # GET /players
    def index
      respond_to do |format|
        format.html {
          @title = "#{@team.team_name} - Game Archives"
        }
        format.json {
          @games = @team.games
          render json: {
            data: @games.reverse.map{ |game|
              {
                id:          game.id,
                result:      game.result,
                opponent:    game.opponent,
                competition: game.competition,
                score:       game.score,
                motm:        game.motm,
                date_played: time_to_string(game.date_played, '%B %e, %Y')
              }
            }
          }.to_json
        }
      end
    end

    # GET /players/1
    def show
      @title = "#{@team.team_name} - Game Record"
      
      # Prepare Copy Table
      @data = { 
        # names: [], 
        ratings: [],
        goals: [],
        assists: []
      }
      player_ids = @game.player_records.map(&:player_id)
      @team.sorted_players.each do |player|
        played = player_ids.include?(player.id)
        record = PlayerRecord.where(game_id: @game.id, player_id: player.id).first
        
        # @data[:names].push(player.names)
        @data[:ratings].push(played ? record.rating  : nil)
        @data[:goals].push  (played ? record.goals   : nil)
        @data[:assists].push(played ? record.assists : nil)
      end
      
      respond_to do |format|
        format.html
        format.xlsx
      end
    end

    # GET /players/new
    def new
      @title = "#{@team.team_name} - New Game"
      @last_played = @team.games.last.date_played unless @team.games.empty?
      @game = Game.new
      @game.build_records
    end

    # GET /players/1/edit
    def edit
      @title = "#{@team.team_name} - Edit Game"
    end

    # POST /players
    def create
      @game = Game.new(game_params)

      puts "Hello"
      puts @games.inspect

      if @team.games.push @game
        redirect_to @game, notice: 'Game was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /players/1
    def update
      if @game.update(game_params)
        redirect_to @game, notice: 'Game was successfully updated.'
      else
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
        @game = Game.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def game_params
        params[:game].permit!
      end
  end
end
