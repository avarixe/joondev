module Cmsk
  module ApplicationHelper
    def time_to_string(time, string)
      time.present? ? time.strftime(string) : nil
    end
  end
end
