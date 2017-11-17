module MyFifa
  # :nodoc:
  module AnalyticsHelper

    def set_player_data
      @values = @players.map do |player|
        {
          name: player.name,
          ratings: set_player_ratings(player),
          recent_form: set_player_recent_form(player),
          values: set_player_values(player),
          ovr: set_player_ovr(player)
        }
      end
    end

    def set_player_ratings(player)
      player.records.map do |record|
        [ record.match.date_played, record.rating ]
      end
    end

    def set_player_recent_form(player)
      @recent_matches.map do |m|
        [m.date_played, player.match_rating(m)]
      end
    end

    def set_player_values(player)
      @seasons
      .map { |s| [s.title, player.season_value(s)] }
      .unshift(['Start Value', player.start_value])
    end

    def set_player_ovr(player)
      @seasons
      .map { |s| [s.title, player.season_ovr(s)] }
      .unshift(['Start OVR', player.start_ovr])
    end
  end
end
