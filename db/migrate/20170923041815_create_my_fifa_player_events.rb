class CreateMyFifaPlayerEvents < ActiveRecord::Migration
  def change
    create_table :my_fifa_player_events do |t|
      t.string :type
      t.belongs_to :player

      t.date :date_effective
      t.date :date_expires
      t.text :notes
    end
  end
end
