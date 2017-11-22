module MyFifa
  class PlayerStatusBroadcastJob < ApplicationJob
    queue_as :default

    def perform(player)
      puts 'performing PlayerStatusBroadcastJob'
      PlayersChannel.broadcast_to "room-#{player.team_id}:player_updates",
        id:     player.id,
        name:   player.name,
        pos:    player.pos,
        active: player.active?,
        status: player.status
    end
  end
end