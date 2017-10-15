require_dependency "my_fifa/application_controller"

module MyFifa
  class CompetitionsController < ApplicationController
    before_action :set_competition, only: [:edit, :update]
    before_action :set_current_team

    def new
      @competition = @team.competitions.new
      @title = 'New Competition'
    end

    # GET /players/1/edit
    def edit
      @title = @competition.title
    end

    # POST /competitions
    def create
      @competition = Competition.new(competition_params)

      if @team.current_season.competitions << @competition
        redirect_to @competition.season, notice: 'Competition was successfully created.'
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @competition } }
        end
      end
    end

    def update
      @competition.update(competition_params)
      redirect_to @competition.season, notice: "#{@competition.title} was successfully updated."
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
