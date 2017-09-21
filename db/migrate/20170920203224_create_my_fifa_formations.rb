class CreateMyFifaFormations < ActiveRecord::Migration
  def change
    create_table :my_fifa_formations do |t|
      t.belongs_to :team

      t.string :title
      t.string :layout
      
      t.integer :pos_1
      t.integer :pos_2
      t.integer :pos_3
      t.integer :pos_4
      t.integer :pos_5
      t.integer :pos_6
      t.integer :pos_7
      t.integer :pos_8
      t.integer :pos_9
      t.integer :pos_10
      t.integer :pos_11

      t.timestamps null: false
    end
    
    add_column :my_fifa_squads, :formation_id, :integer
  end
end
