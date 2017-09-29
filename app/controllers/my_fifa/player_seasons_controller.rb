require_dependency "my_fifa/application_controller"

module MyFifa
  class PlayerSeasonsController < ApplicationController
    before_action :set_player_season, only: [:update]
    before_action :set_current_team

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.json {
          @player_season.update(player_season_params)
          puts @player_season.errors.full_messages
          respond_with_bip(@player_season)
        }
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