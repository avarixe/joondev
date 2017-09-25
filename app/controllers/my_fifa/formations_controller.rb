require_dependency "my_fifa/application_controller"

module MyFifa
  class FormationsController < ApplicationController
    before_action :set_formation, only: [:show, :update]

    # GET /players
    def index
      @title = "Formations"
      @formations = current_user.formations
    end

    # GET /players/1
    def show
      @title = "Formation: #{@formation.title}"
      render :form
    end

    # GET /players/new
    def new
      @title = "New Formation"
      @formation = Formation.new(layout: '4-3-3')
      render :form
    end

    # POST /players
    def create
      @formation = Formation.new(formation_params)

      respond_to do |format|
        if current_user.formations << @formation
          format.js
        else
          format.js { render 'shared/errors', locals: { object: @formation } }
        end
      end
    end

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.js {
          if @formation.update(formation_params)
            render
          else
            render 'shared/errors', locals: { object: @formation }
          end
        }
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

      # Only allow a trusted parameter "white list" through.
      def formation_params
        params[:formation].permit!
      end
  end
end
