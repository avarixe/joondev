require_dependency "my_fifa/application_controller"

module MyFifa
  class FormationsController < ApplicationController
    before_action :set_formation, only: [:show, :update, :destroy]

    # GET /players
    def index
      respond_to do |format|
        format.html {
          @title = "Manage Formations"
        }
        format.json {
          render json: {
            data: current_user.formations
          }.to_json
        }
      end
    end

    # GET /players/1
    def show
      render_form_json
    end

    # GET /players/new
    def new
      @formation = Formation.new(layout: '4-2-3-1')
      render_form_json
    end

    # POST /players
    def create
      @formation = Formation.new(formation_params)
      respond_to do |format|
        format.js {
          unless current_user.formations << @formation
            render 'shared/errors', locals: { object: @formation }
          end
        }
      end
    end

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.js {
          unless @formation.update(formation_params)
            render 'shared/errors', locals: { object: @formation }
          end
        }
      end
    end

    def destroy
      @error =
        if @formation.squads.any?
          "There is still a Squad using this Formation #{@formation.title}."
        elsif @formation.id == current_user.formation_id
          "Formation #{@formation.title} is currently set as Active and cannot be removed."
        elsif !@formation.destroy
          "Formation #{@formation.title} could not be removed."
        end

      puts @error

      respond_to do |format|
        format.js
      end
    end

    def set_active
      current_user.update_column(:formation_id, params[:id])
      head :ok
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_formation
        @formation = Formation.find(params[:id])
      end

      def render_form_json
        render json: render_to_string(template: "my_fifa/formations/form.html", layout: false).to_json            
      end

      # Only allow a trusted parameter "white list" through.
      def formation_params
        params[:formation].permit!
      end
  end
end
