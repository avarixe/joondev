class ChangePlayerRecordInjuryToString < ActiveRecord::Migration
  def change
    remove_column :my_fifa_player_records, :injured, :boolean
    add_column :my_fifa_player_records, :injury, :string
  end
end
