class RenameLeagueToSeason < ActiveRecord::Migration
  def change
    rename_table :cmsk_leagues, :cmsk_seasons

    rename_column :cmsk_seasons, :season, :league

    rename_column :cmsk_fixtures, :league_id, :season_id
  end
end
