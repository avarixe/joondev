module MyFifa
  # :nodoc:
  module PlayersHelper
    # Top Player among players_with_records based on criteria
    def top_player(players_with_records, criteria)
      players_with_records.max_by do |_, records|
        PlayerRecord.public_send(criteria, records)
      end.first
    end

    # Toggle Player Events
    def toggle_player_status
      player_event = "player_#{params[:type]}_event"
      return unless params[:type] && respond_to?(player_event)
      public_send(player_event)
    end

    def player_injury_event
      @player.toggle_injury(@date, params[:notes])
      @icon = 'pink first aid'
      @message = "#{@player.name} is injured."
    end

    def player_recover_event
      @player.toggle_injury(@date, params[:notes])
      if @player.injured?
        @icon = 'pink first aid'
        @message = "#{@player.name} Injury Status has been updated."
      else
        @icon = 'green first aid'
        @message = "#{@player.name} is no longer injured."
      end
    end

    def player_loan_event
      @player.toggle_loan(@date, params[:notes])
      @icon = 'orange plane'
      @message = "#{@player.name} has been loaned out."
    end

    def player_return_event
      @player.toggle_loan(@date, params[:notes])
      @icon = 'green plane'
      @message = "#{@player.name} has returned to the club."
    end
  end
end
