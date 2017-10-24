module MyFifa
  module MatchAnalytics
    def filter_matches
      query = {
        strings: [],
        args: []
      }

      if params[:season].present?
        season = Season.find(params[:season])

        query[:strings] << 'date_played BETWEEN ? AND ?'
        query[:args] += [season.start_date, season.end_date]
      end

      if params[:competition].present?
        query[:strings] << 'competition = ?'
        query[:args] << params[:competition]
      end

      @matches = query[:strings].any? ?
        Match.where(query[:strings].join(' AND '), *query[:args]) : Match.all
    end

    def filter_records
      filter_matches
      @records = @records.where(match_id: @matches.map(&:id))
    end
  end
end