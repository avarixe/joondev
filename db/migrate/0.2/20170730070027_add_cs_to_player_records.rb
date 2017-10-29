class AddCsToPlayerRecords < ActiveRecord::Migration
  def change
    add_column :cmsk_player_records, :cs, :boolean
  end
end
