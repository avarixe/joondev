require_dependency 'my_fifa/application_controller'

module MyFifa
  # :nodoc:
  class TeamsController < ApplicationController
    before_action :set_team, only: %i[show edit update destroy]
    before_action :restrict_to_user, only: %i[show edit update destroy]

    # GET /teams
    def index
      @title = 'Teams'
    end

    # GET /teams/1
    def show
      @title = @team.team_name
    end

    # GET /teams/new
    def new
      @team = Team.new
      @title = 'New Team'
    end

    # GET /teams/1/edit
    def edit
      @title = 'Edit Team'
    end

    # POST /teams
    def create
      @team = Team.new(team_params)

      if current_user.teams.push @team
        redirect_to @team, notice: 'Team was successfully created.'
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @team } }
        end
      end
    end

    # PATCH/PUT /teams/1
    def update
      if @team.update(team_params)
        redirect_to @team, notice: 'Team was successfully updated.'
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @team } }
        end
      end
    end

    # DELETE /teams/1
    def destroy
      @team.destroy
      redirect_to teams_url, notice: 'Team was successfully destroyed.'
    end

    def set_active
      current_user.update_column(:team_id, params[:id])
      head :ok
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    def restrict_to_user
      redirect_to action: 'index' unless current_user.teams.include? @team
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params[:team].permit!
    end
  end
end
