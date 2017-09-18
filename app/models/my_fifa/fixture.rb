module MyFifa
  class Fixture < Base
    self.table_name = 'my_fifa_fixtures'
    default_scope { order(id: :asc)}

    belongs_to :team
    has_many :player_records
    has_many :players, through: :player_records

    belongs_to :fixture

    belongs_to :motm, class_name: 'Player'
    scope :with_motm, -> { 
      joins('LEFT JOIN my_fifa_players ON my_fifa_fixtures.motm_id = my_fifa_players.id')
        .select('my_fifa_fixtures.*, my_fifa_players.name AS motm_name')
    }

    accepts_nested_attributes_for :player_records, reject_if: :invalid_record?
    after_save :set_records
    after_save :set_fixture

    def invalid_record?(attributed)
      attributed['pos'].blank?
    end

    def build_records
      Squad.positions.each do |pos|
        self.player_records.build(
          pos: pos
        )
      end
    end
    
    def set_records
      self.player_records.each do |record|
        record.team_id = self.team_id
        record.cs = self.score_ga == 0
        record.save
      end

      # TODO: Remove after I add radio buttons to select MOTM
      motm_id = self.player_records.sort_by(&:rating).last.player_id
      update_column(:motm_id, motm_id)
    end
 
    def score
      [
        self.score_gf,
        self.penalties_gf.present? ? " (#{self.penalties_gf})" : '',
        ' - ',
        self.score_ga,
        self.penalties_ga.present? ? " (#{self.penalties_ga})" : ''
      ].join('')
    end
        
    def result
      if self.score_gf > self.score_ga
        'positive'
      elsif self.score_gf == self.score_ga
        'warning'
      else
        'negative'
      end
    end
  end
end
