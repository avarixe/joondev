class CreateMyFifaLeagueResults < ActiveRecord::Migration
  def change
    create_table :my_fifa_league_results do |t|
      t.belongs_to :league

      t.string :team_name
      t.integer :wins, default: 0
      t.integer :draws, default: 0

      t.integer :goals_for, default: 0
      t.integer :goals_against, default: 0
    end
  end
end
