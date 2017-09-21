module MyFifa
  class Squad < Base
    self.table_name = 'my_fifa_squads'
    default_scope { order(id: :asc)}

    belongs_to :team
    belongs_to :formation
    
    validates :squad_name, presence: { message: "Squad Name can't be blank." }
    (1..11).each do |no|
      validates :"player_id_#{no}", presence: { message: "Position can't be blank."}
    end

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

    def player_ids
      (1..11).map{ |no| self.send("player_id_#{no}") }
    end
    
    def player_names
      Player.find(player_ids.compact).map(&:name).join(', ')
    end
  end
end
