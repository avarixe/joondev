class AddSquadIdToFixture < ActiveRecord::Migration
  def change
    add_column :my_fifa_fixtures, :squad_id, :integer
  end
end
