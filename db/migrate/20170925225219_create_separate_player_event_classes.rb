class CreateSeparatePlayerEventClasses < ActiveRecord::Migration
  def change
    create_table :my_fifa_contracts do |t|
      t.belongs_to :player
      t.date :start_date
      t.string :origin
      t.string :destination
      t.boolean :loan, default: false
    end

    create_table :my_fifa_contract_terms do |t|
      t.belongs_to :player
      t.date :end_date
      t.integer :wage
      t.integer :signing_bonus
      t.integer :stat_bonus
      t.integer :num_stats
      t.string :stat_type
      t.integer :release_clause
    end

    create_table :my_fifa_injuries do |t|
      t.belongs_to :player
      t.date :start_date
      t.date :end_date
    end

    create_table :my_fifa_loans do |t|
      t.belongs_to :player
      t.date :start_date
      t.date :end_date
      t.string :destination
    end
    
    add_column :my_fifa_costs, :add_on_clause, :integer, default: 0
    rename_column :my_fifa_costs, :price, :fee
    rename_column :my_fifa_costs, :event_id, :contract_id
  end
end
