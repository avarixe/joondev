class AddTitleToStage < ActiveRecord::Migration
  def change
    add_column :cmsk_stages, :title, :string
  end
end
