class AddBookingCardsToPlayerRecords < ActiveRecord::Migration
  def change
    add_column :my_fifa_player_records, :yellow_cards, :integer, default: 0
    add_column :my_fifa_player_records, :red_cards, :integer, default: 0
    
    remove_column :my_fifa_player_records, :booking, :integer
  end
end
