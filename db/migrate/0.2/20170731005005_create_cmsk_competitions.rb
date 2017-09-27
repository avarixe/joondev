class CreateCmskCompetitions < ActiveRecord::Migration
  def change
    create_table :cmsk_competitions do |t|
      t.belongs_to :team, index: true, null: false
      t.string :season, null: false
      t.string :title, null: false

      t.timestamps null: false
    end

    remove_column :cmsk_teams, :competitions
  end
end
