require_dependency 'my_fifa/application_controller'

module MyFifa
  # :nodoc:
  class FormationsController < ApplicationController
    before_action :set_formation, only: %i[show update destroy info]

    # GET /players
    def index
      respond_to do |format|
        format.html do
          @title = 'Manage Formations'
        end
        format.json do
          render json: {
            data: current_user.formations
          }.to_json
        end
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
        format.js do
          unless current_user.formations << @formation
            render 'shared/errors', locals: { object: @formation }
          end
        end
      end
    end

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.js do
          unless @formation.update(formation_params)
            render 'shared/errors', locals: { object: @formation }
          end
        end
      end
    end

    def destroy
      @error =
        if @formation.squads.any?
          "There is still a Squad using this Formation #{@formation.title}."
        elsif @formation.id == current_user.formation_id
          "Formation #{@formation.title} is currently" \
          'set as Active and cannot be removed.'
        elsif !@formation.destroy
          "Formation #{@formation.title} could not be removed."
        end
      respond_to { |format| format.js }
    end

    def set_active
      current_user.update_column(:formation_id, params[:id])
      head :ok
    end

    def info
      render json: @formation.to_json
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_formation
      @formation = Formation.find(params[:id])
    end

    def render_form_json
      render_html_json('formations/form')
    end

    # Only allow a trusted parameter "white list" through.
    def formation_params
      params[:formation].permit!
    end
  end
end
