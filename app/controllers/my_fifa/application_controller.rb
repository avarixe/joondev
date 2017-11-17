module MyFifa
  # :nodoc:
  class ApplicationController < ::ApplicationController
    private

      def set_current_team
        @team = current_user.default_team
      end

      def team_is_playable?
        return redirect_to(my_fifa_players_path) unless @team.playable?
      end

      def render_html_json(path)
        respond_to do |format|
          format.json do
            render json:
              render_to_string(
                template: "/my_fifa/#{path}.html",
                layout: false
              ).to_json
          end
        end
      end
  end
end
