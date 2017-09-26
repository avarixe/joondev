class RenameContractTermPlayerIdToContractId < ActiveRecord::Migration
  def change
    rename_column :my_fifa_contract_terms, :player_id, :contract_id
  end
end
