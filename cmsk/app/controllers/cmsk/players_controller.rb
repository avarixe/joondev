require_dependency "cmsk/application_controller"

module Cmsk
  class PlayersController < ApplicationController
    before_action :set_current_team

    # GET /players
    def index
      @players = @team.players
      @title = "#{@team.team_name} - Players"
    end

    # GET /players/new
    def new
      @player = Player.new
      @title = "#{@team.team_name} - New Player"
    end

    # POST /players
    def create
      @player = Player.new(player_params)

      if @team.players.push @player
        redirect_to action: 'index'
      else
        render :new
      end
    end

    # POST /players/update_json
    def update_json
      @player = Player.find(params[:id])
  
      status, message = 
        if @team.players.include? @player
          @player.update_attributes(player_params) ? 
            ['success', 'Player has been updated.'] : 
            ['error', 'Player could not be updated.']
        else
          ['error', 'You cannot access this Player.']
        end

      render_json_response(status, message)
    end

    private
      # Only allow a trusted parameter "white list" through.
      def player_params
        params[:player].permit!
      end
  end
end
