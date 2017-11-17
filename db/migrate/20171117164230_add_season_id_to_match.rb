class AddSeasonIdToMatch < ActiveRecord::Migration
  def change
    add_column :my_fifa_matches, :season_id, :integer
  end
end
