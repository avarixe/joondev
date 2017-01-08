module Cmsk
  class ApplicationController < ::ApplicationController
    before_filter :set_module
    before_filter :set_team_cookie

    private
    
    def set_module
      @title = 'CMSK'
      @module = 'Career Mode Stat Keeper'
    end
    
    def set_team_cookie
      unless current_user.teams.blank?
        cookies[:team] = current_user.teams.first.id if cookies[:team].blank?
      end
    end
    
    def set_current_team
      return redirect_to url_for(controller: :teams, action: :index) if cookies[:team].blank?
      @team = Team.find(cookies[:team].to_i)
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
