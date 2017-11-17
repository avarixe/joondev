class AddNumAdvancesToCompetitions < ActiveRecord::Migration
  def change
    rename_column :my_fifa_competitions, :num_advances_per_group, :num_advances
  end
end
