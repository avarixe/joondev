require_dependency "my_fifa/application_controller"

module MyFifa
  class SquadsController < ApplicationController
    before_action :set_squad, only: [:show, :update, :players_json]
    before_action :set_current_team

    # GET /players
    def index
      @title = "Squads"
      @squads = @team.squads
    end

    # GET /players/1
    def show
      @title = @squad.squad_name
      set_squad_form
    end

    # GET /players/new
    def new
      @title = "New Squad"
      @squad = Squad.new
      set_squad_form
    end

    # POST /players
    def create
      @squad = Squad.new(squad_params)

      if @team.squads.push @squad
        redirect_to @squad, notice: 'Squad was successfully created.'
      else
        @title = "New Squad"
        set_squad_form
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

      def set_squad_form
        @grouped_players = @team.grouped_players
        puts @grouped_players.inspect
        render :new
      end

      # Only allow a trusted parameter "white list" through.
      def squad_params
        params[:squad].permit!
      end
  end
end
