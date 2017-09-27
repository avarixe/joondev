class AddTeamFormationDefaultsToUser < ActiveRecord::Migration
  def change
    add_column :users, :team_id, :integer
    add_column :users, :formation_id, :integer
  end
end
