module MyFifa
  class Base < ActiveRecord::Base
    self.abstract_class = true

    include ApplicationHelper

    def set_current_date(team, date)
      if date.present? && team.current_date < date
        team.update_column(:current_date, date)
      end
    end
  end
end
