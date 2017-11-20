module MyFifa
  # Base Class for MyFifa Manager models
  class Base < ApplicationRecord
    self.abstract_class = true

    def self.table_name_prefix
      'my_fifa_'
    end

    include ApplicationHelper

    def set_current_date(team, date)
      return unless date.present? && team.current_date < date
      team.update_column(:current_date, date)
    end
  end
end
