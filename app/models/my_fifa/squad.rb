module MyFifa
  class Squad < Base
    self.table_name = 'my_fifa_squads'
    default_scope { order(id: :asc)}

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
      (1..11).each { |no|
        player = Player.find(self.send("player_id_#{no}")) rescue nil
        names << player.name if player.present?
      }
      names.join(', ')
    end
  end
end
