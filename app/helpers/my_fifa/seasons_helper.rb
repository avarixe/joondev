module MyFifa
  # :nodoc:
  module SeasonsHelper
    def set_accolades
      @accolades = {
        top_rank:        top_rank(@season_players),
        top_goalscorer:  top_goalscorer(@season_players),
        top_playmaker:   top_playmaker(@season_players),
        top_goalkeeper:  top_goalkeeper(@season_players),
        top_under_21:    top_under_21(@season_players),
        top_new_arrival: top_new_arrival(@season_players)
      }
    end

    def top_rank(sp)
      sp.sort_by(&:rank).last
    end

    def top_goalscorer(sp)
      sp.select(&:goals).sort_by(&:goals).last
    end

    def top_playmaker(sp)
      sp.select(&:assists).sort_by(&:assists).last
    end

    def top_goalkeeper(sp)
      sp = sp.select { |player| player.pos == 'GK' }
      top_rank(sp)
    end

    def top_under_21(sp)
      sp = sp.select { |player| player.age < 21 }
      top_rank(sp)
    end

    def top_new_arrival(sp)
      sp = sp.select do |player|
        (@season.start_date..@season.end_date).cover? player.date_joined
      end
      top_rank(sp)
    end
  end
end
