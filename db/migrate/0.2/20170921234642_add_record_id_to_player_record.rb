class AddRecordIdToPlayerRecord < ActiveRecord::Migration
  def change
    add_column :my_fifa_player_records, :record_id, :integer
  end
end
