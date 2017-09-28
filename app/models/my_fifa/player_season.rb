module MyFifa
  class PlayerSeason < Base
    default_scope { order(id: :asc) }
    
    belongs_to :season
    belongs_to :player
    
    validates_numericality_of :jersey_no
    validates_numericality_of :age
    validates_numericality_of :ovr
  end
end
