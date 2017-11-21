module MyFifa
  # :nodoc:
  class ApplicationController < ::ApplicationController
    before_filter :set_system
    before_action :authenticate_my_fifa_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

      def configure_permitted_parameters
        added_attrs = [:username, :email, :full_name, :password, :password_confirmation]
        devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
        devise_parameter_sanitizer.permit :account_update, keys: added_attrs << :current_password
      end

    private

      def set_system
        @system = 'MyFifa'
      end

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
