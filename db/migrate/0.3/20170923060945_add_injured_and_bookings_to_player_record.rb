class AddInjuredAndBookingsToPlayerRecord < ActiveRecord::Migration
  def change
    add_column :my_fifa_player_records, :injured, :boolean, default: false
    add_column :my_fifa_player_records, :booking, :integer, default: 0
  end
end
