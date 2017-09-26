module MyFifa
  class Base < ActiveRecord::Base
    self.abstract_class = true
    default_scope { order(id: :asc) }

    include Helper

    def set_current_date(team, date)
      if date.present? && team.current_date < date
        team.update_column(:current_date, date)
      end
    end
  end
end
