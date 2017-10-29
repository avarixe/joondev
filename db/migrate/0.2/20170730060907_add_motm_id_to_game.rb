class AddMotmIdToGame < ActiveRecord::Migration
  def change
    add_column :cmsk_games, :motm_id, :integer
  end
end
