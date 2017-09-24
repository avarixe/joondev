class CreateMyFifaCosts < ActiveRecord::Migration
  def change
    create_table :my_fifa_costs do |t|
      t.belongs_to :player
      t.integer :price
      t.integer :traded_id
      t.text :notes
    end
  end
end
