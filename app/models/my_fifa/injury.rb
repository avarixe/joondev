module MyFifa
  class Injury < Event
    self.table_name = 'my_fifa_injuries'
    
    belongs_to :player
  end
end