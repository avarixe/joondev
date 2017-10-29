class CreateMyFifaMatchLogs < ActiveRecord::Migration
  def change
    create_table :my_fifa_match_logs do |t|
      t.belongs_to :match

      t.string :event
      t.integer :minute

      t.belongs_to :player1
      t.belongs_to :player2

      t.text :notes
    end
  end
end
