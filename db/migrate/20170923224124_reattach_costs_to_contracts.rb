class ReattachCostsToContracts < ActiveRecord::Migration
  def change
    rename_column :my_fifa_costs, :traded_id, :event_id
    remove_column :my_fifa_players, :origin, :string
    remove_column :my_fifa_players, :destination, :string
    remove_column :my_fifa_players, :loan, :boolean
    add_column :my_fifa_player_events, :party, :string
    add_column :my_fifa_player_events, :loan, :boolean, default: :false
  end
end
