require_dependency "cmsk/application_controller"

module Cmsk
  class CompetitionsController < ApplicationController
    before_action :set_competition, only: [:show, :edit, :update, :destroy]
    before_action :set_current_team

    # GET /competitions
    def index
      @page = "Competitions"
      @competitions = Competition.all
    end

    # GET /competitions/1
    def show
      @page = @competition.title
    end

    # GET /competitions/new
    def new
      @page = "New Competition"
      @competition = @team.competitions.new
    end

    # GET /competitions/1/edit
    def edit
      @page = "Edit Competition"
    end

    # POST /competitions
    def create
      @competition = @team.competitions.build(competition_params)

      if @team.competitions.push @competition
        redirect_to @competition, notice: 'Competition was successfully created.'
      else
       render :new
      end
    end

    # PATCH/PUT /competitions/1
    def update
      if @competition.update(competition_params)
        redirect_to @competition, notice: 'Competition was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /competitions/1
    def destroy
      @competition.destroy
      redirect_to competitions_url, notice: 'Competition was successfully destroyed.'
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
