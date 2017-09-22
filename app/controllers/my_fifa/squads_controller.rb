require_dependency "my_fifa/application_controller"

module MyFifa
  class SquadsController < ApplicationController
    before_action :set_squad, only: [:show, :update, :info]
    before_action :set_current_team

    # GET /players
    def index
      @title = "Squads"
      @squads = @team.squads
    end

    # GET /players/1
    def show
      @formation = @squad.formation
      @title = @squad.squad_name
      set_squad_form
    end

    # GET /players/new
    def new
      @formation = Formation.find(session[:formation])
      @title = "New Squad"
      @squad = @formation.squads.new
      set_squad_form
    end

    # POST /players
    def create
      @squad = Squad.new(squad_params)

      if @team.squads.push @squad
        redirect_to @squad, notice: 'Squad was successfully created.'
      else
        respond_to do |format|
          format.js { render 'my_fifa/shared/errors', locals: { object: @squad } }
        end
      end
    end

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.js {
          if @squad.update(squad_params)
            render
          else
            render 'my_fifa/shared/errors', locals: { object: @squad }
          end
        }
      end
    end

    def info
      render json: {
        player_ids: (1..11).map{ |no| @squad.send("player_id_#{no}") },
        positions: @squad.formation.positions
      }
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_squad
        @squad = Squad.find(params[:id])
      end

      def set_squad_form
        @grouped_players = @team.grouped_players(abbrev: true)
        render :form
      end

      # Only allow a trusted parameter "white list" through.
      def squad_params
        params[:squad].permit!
      end
  end
end
