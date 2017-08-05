class AddTeamIdToFixture < ActiveRecord::Migration
  def change
    add_column :cmsk_fixtures, :team_id, :integer
    add_column :cmsk_stages, :team_id, :integer
  end
end
