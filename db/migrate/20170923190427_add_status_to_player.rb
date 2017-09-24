class AddStatusToPlayer < ActiveRecord::Migration
  def change
    add_column :my_fifa_players, :status, :string, default: ''
  end
end
