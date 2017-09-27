class RenameFixtureToMatch < ActiveRecord::Migration
  def change
    rename_table :my_fifa_fixtures, :my_fifa_matches

    rename_column :my_fifa_player_records, :fixture_id, :match_id

    remove_column :my_fifa_matches, :fixture_id, :integer
  end
end
