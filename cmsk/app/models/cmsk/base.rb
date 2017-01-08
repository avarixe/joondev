module Cmsk
  class Base < ActiveRecord::Base
    self.abstract_class = true
    
    # establish_connection(:cmsk_db)
  end
end
