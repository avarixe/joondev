class RecordTeamsPlayed < ActiveRecord::Migration
  def change
    add_column :my_fifa_teams, :teams_played, :text
    remove_column :my_fifa_teams, :competitions, :text
    add_column :my_fifa_seasons, :competitions, :text
  end
end
