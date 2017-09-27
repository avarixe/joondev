class CreateMyFifaSeasons < ActiveRecord::Migration
  def change
    create_table :my_fifa_seasons do |t|
      t.belongs_to :team
      t.belongs_to :captain

      t.date :start_date
      t.date :end_date

      t.integer :start_club_worth
      t.integer :end_club_worth

      t.integer :transfer_budget
      t.integer :wage_budget
    end
  end
end
