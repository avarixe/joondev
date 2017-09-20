module MyFifa
  class Player < Base
    self.table_name = 'my_fifa_players'
    default_scope { sorted.order(id: :asc) }

    belongs_to :team
    has_many :records, class_name: 'PlayerRecord'
    has_many :fixtures, through: :records

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    scope :with_stats, -> (fixture_ids) {
      relevant_records = " records.player_id = my_fifa_players.id"
      relevant_records += " AND records.fixture_id IN (#{fixture_ids.join(', ')})" if fixture_ids.any?
      joins("LEFT JOIN my_fifa_player_records AS records ON #{relevant_records}").group('my_fifa_players.id')
        .select([
          'my_fifa_players.*',
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
          "WHEN my_fifa_players.pos = '#{pos}' THEN #{i+1}"
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

    def current_ovr
      self.records.last.ovr rescue self.start_ovr
    end

    # STATISTICS
    def num_games()   records.count end
    def num_motm()    records.select{ |r| r.motm? }.count end
    def num_goals()   records.map(&:goals).compact.inject(0, :+) end
    def num_assists() records.map(&:assists).compact.inject(0, :+) end
    def num_cs()      records.where(cs: 1).count end

  end
end
