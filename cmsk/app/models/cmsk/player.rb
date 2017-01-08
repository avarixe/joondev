module Cmsk
  class Player < Cmsk::Base
    belongs_to :team
    scope :active, -> { where(active: true) }

    POSITIONS = [
      'GK',
      'CB',
      'LB',
      'LWB',
      'RB',
      'RWB',
      'CDM',
      'CM',
      'LM',
      'RM',
      'CAM',
      'CF',
      'LW',
      'RW',
      'ST'
    ]
    
    def self.positions
      POSITIONS
    end
    
    def shorthand_name
      names = self.name.split(' ')
      names.length == 1 ? self.name : "#{names.first[0]}. #{names.drop(1).join(' ')}"
    end
  end
end
