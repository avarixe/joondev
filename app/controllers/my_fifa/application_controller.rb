module MyFifa
  class ApplicationController < ::ApplicationController
    helper Helper
    include Helper
    before_filter :set_module_session

    private
    
      def set_module_session
        session[:team] = current_user.teams.last.id if session[:team].blank? && current_user.teams.any?
        session[:formation] = current_user.formations.first.id if session[:formation].blank? && current_user.formations.any?
      end
      
      def set_current_team
        return redirect_to url_for(controller: :teams, action: :index) if session[:team].blank?
        @team = Team.find(session[:team].to_i)
      end
      
      def render_json_response(status, message)
        respond_to do |format|
          format.json {
            render json: {
              header: status.capitalize,
              message: message,
              status: status
            }
          }
        end
      end
  end
end
