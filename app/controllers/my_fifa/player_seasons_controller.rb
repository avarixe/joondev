require_dependency "my_fifa/application_controller"

module MyFifa
  class PlayerSeasonsController < ApplicationController
    before_action :set_player_season, only: [:update]
    before_action :set_current_team

    # PATCH/PUT /players/1
    def update
      respond_to do |format|
        format.json {
          if @player_season.update(player_season_params)
            render json: @player_season
          else
            render :nothing => true
          end
        }
      end
    end
    
    private
    
      def set_player_season
        @player_season = PlayerSeason.find(params[:id])
      end
      
      def player_season_params
        params[:player_season].permit!
      end
  end
end
