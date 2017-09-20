class AddOvrToPlayerRecord < ActiveRecord::Migration
  def change
    add_column :my_fifa_player_records, :ovr, :integer, default: 0

    add_column :my_fifa_players, :start_ovr, :integer, default: 0
  end
end
