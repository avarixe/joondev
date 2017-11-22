module MyFifa
  class PlayersChannel < ActionCable::Channel::Base
    def subscribed
      stream_from "my_fifa:players:room-#{params[:room]}:player_updates"
    end
  end
end