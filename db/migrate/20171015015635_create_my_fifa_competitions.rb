class CreateMyFifaCompetitions < ActiveRecord::Migration
  def change
    create_table :my_fifa_competitions do |t|
      t.string :type
      t.belongs_to :team
      t.belongs_to :season

      t.string :title
      t.string :champion

      t.integer :num_teams, default: 16
      t.integer :matches_per_fixture, default: 1
    end

    remove_column :my_fifa_seasons, :competitions, :text
  end
end
