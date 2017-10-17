class RenameLeagueResultToGroupResult < ActiveRecord::Migration
  def change
    rename_table :my_fifa_league_results, :my_fifa_group_results
    
    rename_column :my_fifa_group_results, :league_id, :competition_id
    add_column :my_fifa_group_results, :group, :string
    
    add_column :my_fifa_competitions, :num_groups, :integer
    add_column :my_fifa_competitions, :num_advances_per_group, :integer
  end
end
