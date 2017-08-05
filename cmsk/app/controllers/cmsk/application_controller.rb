module Cmsk
  class ApplicationController < ::ApplicationController
    helper Helper
    include Helper
    before_filter :set_module
    before_filter :set_team_cookie

    private
    
    def set_module
      @title = 'CMSK'
      @module = 'Career Mode Stat Keeper'
    end
    
    def set_team_cookie
      session[:team] = current_user.teams.last.id if session[:team].blank? && current_user.teams.any?
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
