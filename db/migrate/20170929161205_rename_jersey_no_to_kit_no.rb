class RenameJerseyNoToKitNo < ActiveRecord::Migration
  def change
    rename_column :my_fifa_player_seasons, :jersey_no, :kit_no
  end
end
