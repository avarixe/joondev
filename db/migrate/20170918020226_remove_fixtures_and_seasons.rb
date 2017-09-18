class RemoveFixturesAndSeasons < ActiveRecord::Migration
  def change
    drop_table :my_fifa_fixtures
    drop_table :my_fifa_seasons
  end
end
