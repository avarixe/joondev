module Cmsk
  class Player < Cmsk::Base
    default_scope { sorted.order(id: :asc) }

    belongs_to :team
    has_many :records, class_name: 'PlayerRecord'
    has_many :games, through: :records

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    scope :with_stats, -> (game_ids) {
      relevant_records = " records.player_id = cmsk_players.id"
      relevant_records += " AND records.game_id IN (#{game_ids.join(', ')})" if game_ids.any?
      joins("LEFT JOIN cmsk_player_records AS records ON #{relevant_records}").group('cmsk_players.id')
        .select([
          'cmsk_players.*',
          "COUNT(records) as gp",
          "AVG(records.rating) as rating",
          "SUM(CASE WHEN records.goals IS NOT NULL THEN records.goals ELSE 0 END) as goals",
          "SUM(CASE WHEN records.assists IS NOT NULL THEN records.assists ELSE 0 END) as assists",
          "SUM(CASE WHEN records.cs = TRUE THEN 1 ELSE 0 END) as cs",
        ].join(', '))
    }

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

    scope :sorted, -> {
      order([
        'CASE',
        *POSITIONS.map.with_index{ |pos, i|
          "WHEN cmsk_players.pos = '#{pos}' THEN #{i+1}"
        },
        'ELSE 100 END ASC'
      ].join(' '))
    }
    
    def self.positions
      POSITIONS
    end
    
    def shorthand_name
      names = self.name.split(' ')
      names.length == 1 ? self.name : "#{names.first[0]}. #{names.drop(1).join(' ')}"
    end
  end
end
