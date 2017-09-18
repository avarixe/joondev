class CreateCmskStages < ActiveRecord::Migration
  def change
    create_table :cmsk_stages do |t|
      t.belongs_to :competition, index: true, null: false
      t.string :category, null: false
      t.integer :num_plays, null: false

      t.text :opponents

      t.timestamps null: false
    end
  end
end
