class ChangeRatingToInteger < ActiveRecord::Migration
  def up
    change_column :my_fifa_player_records, :rating, :integer
  end

  def down
    change_column :my_fifa_player_records, :rating, :float
  end
end
