module MyFifa
  module PlayerAnalytics
    def filter_records
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

      if query[:strings].any?
        @matches = Match.where(query[:strings].join(' AND '), *query[:args])
        @records = @records.where(match_id: @matches.map(&:id))
      else
        @matches = []
      end
    end
  end
end