module MyFifa
  class Loan < Base
    self.table_name = 'my_fifa_loans'
    
    belongs_to :player
  end
end