class AddStartDateToContractTerm < ActiveRecord::Migration
  def change
    add_column :my_fifa_contract_terms, :start_date, :date
    add_column :my_fifa_player_events, :notes, :text
  end
end
