class AddPositionToPlayerRecord < ActiveRecord::Migration
  def change
    Cmsk::Base.connection.add_column :cmsk_player_records, :pos, :string, limit: 10
  end
end
