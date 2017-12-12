module MyFifa
  class ExportController < ApplicationController
    before_action :set_current_team

    def players
      respond_to do |format|
        format.xlsx
      end
    end
  end
end
