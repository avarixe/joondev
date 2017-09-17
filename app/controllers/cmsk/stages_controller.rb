require_dependency "cmsk/application_controller"

module Cmsk
  class StagesController < ApplicationController
    before_action :set_stage
    before_action :set_current_team

    def get_fixtures
      respond_to do |format|
        format.json {
          render json: {
            data: @stage.fixtures.with_game.as_json({ methods: [
              :home_score,
              :away_score,
              :date_played_string,
              :stage_incomplete?
            ]})
          }
        }.to_json
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_stage
        @stage = Stage.find(params[:id])
      end
  end
end