module Cmsk
  class Game < Base
    default_scope { order(id: :asc)}

    belongs_to :team
    has_many :player_records
    has_many :players, through: :player_records

    belongs_to :fixture

    belongs_to :motm, class_name: 'Player'
    scope :with_motm, -> { 
      joins('LEFT JOIN cmsk_players ON cmsk_games.motm_id = cmsk_players.id')
        .select('cmsk_games.*, cmsk_players.name AS motm_name')
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
        record.cs = self.score_gf == 0
        record.save
      end

      # TODO: Remove after I add radio buttons to select MOTM
      motm_id = self.player_records.sort_by(&:rating).last.player_id
      update_column(:motm_id, motm_id)      
    end

    def set_fixture
      if fixture_id.present?
        side, opp_side = team.team_name == fixture.home ? ['home', 'away'] : ['away', 'home']

        fixture.update_columns(
          date_played: date_played,
          :"goals_#{side}"         => score_gf,
          :"penalties_#{side}"     => penalties_gf, 
          :"goals_#{opp_side}"     => score_ga,
          :"penalties_#{opp_side}" => penalties_ga,
        )
        fixture.set_result
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
