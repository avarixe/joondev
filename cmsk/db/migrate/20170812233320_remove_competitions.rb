class RemoveCompetitions < ActiveRecord::Migration
  def change
    drop_table :cmsk_competitions

    add_column :cmsk_teams, :competitions, :text
  end
end
