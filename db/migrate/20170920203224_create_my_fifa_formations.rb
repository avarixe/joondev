class CreateMyFifaFormations < ActiveRecord::Migration
  def change
    create_table :my_fifa_formations do |t|
      t.belongs_to :user

      t.string :title
      t.string :layout
      
      t.string :pos_1, default: 'GK'
      t.string :pos_2, default: 'LB'
      t.string :pos_3, default: 'LCB'
      t.string :pos_4, default: 'RCB'
      t.string :pos_5, default: 'RB'
      t.string :pos_6, default: 'LCM'
      t.string :pos_7, default: 'CM'
      t.string :pos_8, default: 'RCM'
      t.string :pos_9, default: 'LW'
      t.string :pos_10, default: 'ST'
      t.string :pos_11, default: 'RW'

      t.timestamps null: false
    end
    
    add_column :my_fifa_squads, :formation_id, :integer
  end
end
