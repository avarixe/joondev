class RenameStageToLeague < ActiveRecord::Migration
  def change
    rename_table :cmsk_stages, :cmsk_leagues

    remove_column :cmsk_leagues, :num_plays
    remove_column :cmsk_leagues, :category
    remove_column :cmsk_leagues, :competition_id

    add_column :cmsk_leagues, :season, :string

    rename_column :cmsk_fixtures, :stage_id, :league_id
  end
end
