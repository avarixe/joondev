module MyFifa
  class ApplicationController < ::ApplicationController
    helper Helper
    include Helper

    private
          
      def set_current_team
        @team = current_user.default_team
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
