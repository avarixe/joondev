module MyFifa
  class Fixture < Base
    self.table_name = 'my_fifa_fixtures'
    default_scope { order(id: :asc)}

    belongs_to :team
    has_many :player_records
    has_many :players, through: :player_records

    belongs_to :motm, class_name: 'Player'
    scope :with_motm, -> { 
      joins('LEFT JOIN my_fifa_players ON my_fifa_fixtures.motm_id = my_fifa_players.id')
        .select('my_fifa_fixtures.*, my_fifa_players.name AS motm_name')
    }

    accepts_nested_attributes_for :player_records, reject_if: :invalid_record?
    after_save :set_records

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

    # score_f: GF (PF) 
    # score_a: GA (PA) 
    # score: GF (PF) - GA (PA) 
    %w(f a).each do |type|
      define_method "score_#{type}" do
        goals = self.send("score_g#{type}")
        penalties = self.send("penalties_g#{type}")
        "#{goals}#{penalties.present? ? " (#{penalties})" : ''}"
      end

      define_method "score_#{type}=" do |val|
        goals, penalties = val.match(/^(\d+)(?: \((\d+)\))*$/i).captures
        write_attribute :"score_g#{type}", goals
        write_attribute :"penalties_g#{type}", penalties
      end
    end

    def score
      "#{self.score_f} - #{self.score_a}"
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
