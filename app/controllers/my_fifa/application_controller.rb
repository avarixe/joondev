module MyFifa
  class ApplicationController < ::ApplicationController
    helper Helper
    include Helper

    private
          
      def set_current_team
        @team = current_user.default_team
      end

      def team_is_playable?
        return redirect_to(my_fifa_players_path) unless @team.playable?
      end
  end
end
