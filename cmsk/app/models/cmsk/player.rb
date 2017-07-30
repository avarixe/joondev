module Cmsk
  class Player < Cmsk::Base
    default_scope { order(id: :asc)}

    belongs_to :team
    has_many :records, class_name: 'PlayerRecord'
    has_many :game_records, -> { with_game_data }, class_name: 'PlayerRecord'

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

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
      'LW',
      'RW',
      'CAM',
      'CF',
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
