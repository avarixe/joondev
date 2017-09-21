module MyFifa
  class Formation < Base
    self.table_name = 'my_fifa_squads'

    belongs_to :team
    has_many :squads
  end
end
