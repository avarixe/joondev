class AddMotmIdToGame < ActiveRecord::Migration
  def up
    Cmsk::Base.connection.add_column :cmsk_games, :motm_id, :integer

    Cmsk::Game.all.each do |game|
      motm = game.player_records.sort_by(&:rating).last.player
      game.update_attribute(:motm_id, motm.id)
    end
  end

  def down
    Cmsk::Base.connection.remove_column :cmsk_games, :motm_id
  end
end
