module MyFifa
  class Base < ActiveRecord::Base
    self.abstract_class = true

    include Helper
  end
end
