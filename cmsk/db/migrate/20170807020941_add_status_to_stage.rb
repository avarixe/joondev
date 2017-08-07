class AddStatusToStage < ActiveRecord::Migration
  def change
    add_column :cmsk_stages, :status, :integer, default: 0
  end
end
