require_dependency "cmsk/application_controller"

module Cmsk
  class FixturesController < ApplicationController
    before_action :set_fixture, only: [:show, :edit, :update, :destroy]
    before_action :set_current_team

    def update
      if @fixture.stage_incomplete? && @fixture.update_attributes(fixture_params)
        head :ok
      else
        status 500
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_fixture
        @fixture = Fixture.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def fixture_params
        params[:fixture].permit!
      end
  end
end