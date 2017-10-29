class AddPositionToPlayerRecord < ActiveRecord::Migration
  def change
    add_column :cmsk_player_records, :pos, :string, limit: 10
  end
end
