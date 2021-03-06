require_dependency 'my_fifa/application_controller'

module MyFifa
  # :nodoc:
  class PlayerSeasonsController < ApplicationController
    before_action :set_player_season, only: [:update]
    before_action :set_current_team

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.json do
          @player_season.update(player_season_params)
          respond_with_bip(@player_season)
        end
      end
    end

    private

    def set_player_season
      @player_season = PlayerSeason.find(params[:id])
    end

    def player_season_params
      params[:my_fifa_player_season].permit!
    end
  end
end
