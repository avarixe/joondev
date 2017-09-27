class AddTransferInformationToPlayer < ActiveRecord::Migration
  def change
    add_column :my_fifa_players, :nationality, :string
    add_column :my_fifa_players, :year_of_birth, :integer
    add_column :my_fifa_players, :origin, :string
    add_column :my_fifa_players, :destination, :string
    add_column :my_fifa_players, :youth, :boolean, default: false
    add_column :my_fifa_players, :notes, :text
  end
end
