module MyFifa
  class Squad < Base
    self.table_name = 'my_fifa_squads'
    default_scope { order(id: :asc)}

    belongs_to :team
    belongs_to :formation

    DEFAULT_POSITIONS = [
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

    ############################
    #  INITIALIZATION METHODS  #
    ############################
    

    ########################
    #  ASSIGNMENT METHODS  #
    ########################


    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :squad_name, presence: { message: "Squad Name can't be blank." }
      validate :unique_players?

      def unique_players?
        all_pos_filled = true
        (1..11).each do |n|
          if self.send("player_id_#{n}").blank?
            errors.add(:"player_id_#{n}", "#{formation.public_send("pos_#{n}")} is unselected.")
            all_pos_filled = false
          end
        end
        
        if all_pos_filled && player_ids.any?{ |id| player_ids.count(id) > 1 }
          errors.add(:base, "One Player has been assigned to at least two Positions.")
        end
      end

    ######################
    #  CALLBACK METHODS  #
    ######################


    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def player_ids
        (1..11).map{ |n| self.send("player_id_#{n}") }
      end
      
      def player_names
        Player.find(player_ids.compact).map(&:name).join(', ')
      end 
  end
end
