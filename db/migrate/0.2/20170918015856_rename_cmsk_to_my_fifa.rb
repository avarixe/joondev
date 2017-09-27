class RenameCmskToMyFifa < ActiveRecord::Migration
  def change
    rename_table :cmsk_fixtures, :my_fifa_fixtures
    rename_table :cmsk_games, :my_fifa_games
    rename_table :cmsk_player_records, :my_fifa_player_records
    rename_table :cmsk_players, :my_fifa_players
    rename_table :cmsk_seasons, :my_fifa_seasons
    rename_table :cmsk_squads, :my_fifa_squads
    rename_table :cmsk_teams, :my_fifa_teams
  end
end
