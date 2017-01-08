module Cmsk
  class Squad < Cmsk::Base
    belongs_to :team
    
    POSITIONS = [
      'GK',
      'LB',
      'LCB',
      'RCB',
      'RB',
      'LCM',
      'CM',
      'RCM',
      'LW',
      'ST',
      'RW'
    ]
    
    def self.positions
      POSITIONS
    end
    
    def player_names
      names = []
      (1..11).each { |no| names.push(Player.find(self.send("player_id_#{no}")).name) }
      names.join(', ')
    end
  end
end
