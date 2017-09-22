class AddCurrentDateToMyFifaTeam < ActiveRecord::Migration
  def change
    add_column :my_fifa_teams, :current_date, :date
  end
end
