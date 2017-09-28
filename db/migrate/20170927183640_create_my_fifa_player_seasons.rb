class CreateMyFifaPlayerSeasons < ActiveRecord::Migration
  def change
    create_table :my_fifa_player_seasons do |t|
      t.belongs_to :season
      t.belongs_to :player

      t.integer :jersey_no
      t.integer :value
      t.integer :ovr
      t.integer :age, default: 0
    end
    
    add_column :my_fifa_players, :start_value, :integer, default: 0
    add_column :my_fifa_players, :start_age, :integer, default: 0
    remove_column :my_fifa_player_records, :ovr, :integer
    remove_column :my_fifa_players, :year_of_birth, :integer
  end
end
