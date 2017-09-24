class AddLoanToPlayer < ActiveRecord::Migration
  def change
    add_column :my_fifa_players, :loan, :boolean, default: false
  end
end
