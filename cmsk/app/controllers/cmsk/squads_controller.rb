require_dependency "cmsk/application_controller"

module Cmsk
  class SquadsController < ApplicationController
    before_action :set_squad, only: [:show, :update, :players_json]
    before_action :set_current_team

    # GET /players
    def index
      @page = "Squads"
      @squads = @team.squads
    end

    # GET /players/1
    def show
      @page = @squad.squad_name
      @sorted_players = @team.sorted_players
      render :edit
    end

    # GET /players/new
    def new
      @page = "New Squad"
      @sorted_players = @team.sorted_players
      @squad = Squad.new
    end

    # POST /players
    def create
      @squad = Squad.new(squad_params)

      if @team.squads.push @squad
        redirect_to @squad, notice: 'Squad was successfully created.'
      else
        @page = "New Squad"
        @sorted_players = @team.sorted_players
        render :new
      end
    end

    # PATCH/PUT /players/1
    def update
      if @squad.update(squad_params)
        head :ok
      else
        head 500
      end
    end

    def players_json
      render json: {
        players: (1..11).map{ |no| Player.find(@squad.send("player_id_#{no}")) }
      }
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_squad
        @squad = Squad.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def squad_params
        params[:squad].permit!
      end
  end
end
