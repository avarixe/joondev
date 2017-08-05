module Cmsk
  class Fixture < Base
    belongs_to :stage
    has_one :game

    # RESULTS
    #   0 - Unplayed
    #   1 - Home Win
    #   2 - Draw
    #   3 - Away Win

    after_save :set_result

    def set_result
      update_column(
        :result,
        if goals_home.blank? || goals_away.blank?
          0
        elsif goals_home > goals_away
          1
        elsif goals_home < goals_away
          3
        elsif penalties_home.blank? || penalties_away.blank?
          2
        else
          penalties_home > penalties_away ? 1 : 3
        end
      )
    end
  end
end
