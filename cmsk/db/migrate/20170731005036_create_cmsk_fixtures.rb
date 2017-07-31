class CreateCmskFixtures < ActiveRecord::Migration
  def change
    create_table :cmsk_fixtures do |t|
      t.belongs_to :stage, index: true, null: false
      t.integer :result, default: 0, null: false
      t.string  :home, null: false
      t.string  :away, null: false
      t.integer :goals_home, default: 0
      t.integer :goals_away, default: 0
      t.integer :penalties_home
      t.integer :penalties_away

      t.timestamps null: false
    end

    add_column :cmsk_games, :fixture_id, :integer
  end
end
