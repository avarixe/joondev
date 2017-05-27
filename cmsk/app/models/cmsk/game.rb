module Cmsk
  class Game < Base
    default_scope { order(id: :asc)}

    belongs_to :team
    has_many :player_records
    accepts_nested_attributes_for :player_records
    after_save :set_records
    
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
        record.save
      end
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
    
    def motm(full_name=false)
      player = self.player_records.sort_by(&:rating).last.player
      full_name ? player.name : player.shorthand_name
    end
    
    def result
      if self.score_gf > self.score_ga
        'success'
      elsif self.score_gf == self.score_ga
        'warning'
      else
        'danger'
      end
    end
  end
end
