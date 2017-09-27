class RenameGameToFixture < ActiveRecord::Migration
  def change
    rename_table :my_fifa_games, :my_fifa_fixtures

    rename_column :my_fifa_player_records, :game_id, :fixture_id

    add_column :my_fifa_fixtures, :home, :boolean, default: true
  end
end
