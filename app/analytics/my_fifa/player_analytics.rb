module MyFifa
  module PlayerAnalytics
    def top_player(players_with_records, criteria)
      players_with_records.max_by{ |player, records| 
        PlayerRecord.public_send(criteria, records)
      }.first
    end
  end
end