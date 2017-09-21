class CreateMyFifaFormations < ActiveRecord::Migration
  def change
    create_table :my_fifa_formations do |t|
      t.belongs_to :user

      t.string :title
      t.string :layout
      
      t.string :pos_1
      t.string :pos_2
      t.string :pos_3
      t.string :pos_4
      t.string :pos_5
      t.string :pos_6
      t.string :pos_7
      t.string :pos_8
      t.string :pos_9
      t.string :pos_10
      t.string :pos_11

      t.timestamps null: false
    end
    
    add_column :my_fifa_squads, :formation_id, :integer
  end
end
