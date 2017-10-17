require_dependency "my_fifa/application_controller"

module MyFifa
  class CompetitionsController < ApplicationController
    before_action :set_competition, only: [:edit, :update]
    before_action :set_current_team

    def show
      @season = Season.includes(:competitions).find(params[:id])
      @title = "#{@season.title} - Competitions"
    end

    def new
      redirect_to :back if params[:season].blank?
      
      @season = Season.find(params[:season])
      @competition = @season.competitions.new
      @title = 'New Competition'
    end

    # GET /players/1/edit
    def edit
      @title = @competition.title
    end

    # POST /competitions
    def create
      @competition = Competition.new(competition_params)

      if @team.competitions << @competition
        redirect_to my_fifa_competition_path(@competition.season), notice: 'Competition was successfully created.'
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @competition } }
        end
      end
    end

    def update
      @competition.update(competition_params)
      redirect_to my_fifa_competition_path(@competition.season), notice: "#{@competition.title} was successfully updated."
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_competition
        @competition = Competition.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def competition_params
        params[:competition].permit!
      end
  end
end
