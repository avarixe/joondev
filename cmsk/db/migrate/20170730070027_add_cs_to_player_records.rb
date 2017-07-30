class AddCsToPlayerRecords < ActiveRecord::Migration
  def up
    Cmsk::Base.connection.add_column :cmsk_player_records, :cs, :boolean

    Cmsk::PlayerRecord.all.each do |record|
      record.update_attribute(:cs, record.game.score_ga == 0)
    end
  end

  def down
    Cmsk::Base.connection.remove_column :cmsk_player_records, :cs
  end
end
