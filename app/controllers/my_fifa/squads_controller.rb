require_dependency 'my_fifa/application_controller'

module MyFifa
  # :nodoc:
  class SquadsController < ApplicationController
    before_action :set_squad, only: %i[show update info destroy]
    before_action :set_current_team
    before_action :team_is_playable?

    # GET /players
    def index
      respond_to do |format|
        format.html do
          @title = 'Manage Squads'
        end
        format.json do
          render json: { data: @team.squads }.to_json
        end
      end
    end

    # GET /players/1
    def show
      @formation = @squad.formation
      render_form_json
    end

    # GET /players/new
    def new
      @formation = current_user.default_formation
      @squad = @formation.squads.new
      render_form_json
    end

    # POST /players
    def create
      @squad = Squad.new(squad_params)

      respond_to do |format|
        format.js do
          unless @team.squads << @squad
            render 'shared/errors', locals: { object: @squad }
          end
        end
      end
    end

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.js do
          if @squad.update(squad_params)
            render :success
          elsif params[:page] == 'match'
            render :errors
          else
            render 'shared/errors', locals: { object: @squad }
          end
        end
      end
    end

    def destroy
      @squad.destroy
      respond_to do |format|
        format.js
      end
    end

    def info
      render json: {
        player_ids: (1..11).map do |no|
          @squad.send("player_id_#{no}")
        end,
        positions: @squad.formation.positions
      }
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_squad
      @squad = Squad.find(params[:id])
    end

    def render_form_json
      @grouped_players = Player.grouped_by_pos(@team.players.active)
      render_html_json('squads/form')
    end

    # Only allow a trusted parameter "white list" through.
    def squad_params
      params[:squad].permit!
    end
  end
end
