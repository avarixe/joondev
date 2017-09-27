class CreateMyFifaContractTerms < ActiveRecord::Migration
  def change
    add_column :my_fifa_player_events, :origin, :string
    add_column :my_fifa_player_events, :destination, :string

    MyFifa::Contract.all.each do |contract|
      contract.update_columns(
        origin: contract.party,
        destination: contract.notes
      )
    end

    rename_column :my_fifa_player_events, :date_effective, :start_date
    rename_column :my_fifa_player_events, :date_expires, :end_date
    remove_column :my_fifa_player_events, :party
    remove_column :my_fifa_player_events, :notes  

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

    add_column :my_fifa_costs, :add_on_clause, :integer, default: 0
    rename_column :my_fifa_costs, :price, :fee    
  end
end
