module MyFifa
  # :nodoc:
  module MatchesHelper
    def filter_matches
      @query = { strings: [], args: [] }
      generate_query
      @matches = @team.matches
      return unless @query[:strings].any?
      @matches = @matches.where(@query[:strings].join(' AND '), *@query[:args])
    end

    def filter_records
      filter_matches
      @records = @records.where(match_id: @matches.map(&:id))
      @players = @team.players
                 .includes(:records, :player_seasons)
                 .with_stats(@matches.map(&:id))
                 # .where(id: @records.map(&:player_id).uniq)
      return unless str_to_bool(params[:active_only])
      @players = @players.where(active: true)
    end

    private

    def generate_query
      filter_season
      filter_competition
    end

    def filter_season
      return unless params[:season].present?
      season = Season.find(params[:season])
      @query[:strings] << 'date_played BETWEEN ? AND ?'
      @query[:args] += [season.start_date, season.end_date]
    end

    def filter_competition
      return unless params[:competition].present?
      @query[:strings] << 'competition = ?'
      @query[:args] << params[:competition]
    end
  end
end
