class AddDirToCost < ActiveRecord::Migration
  def change
    add_column :my_fifa_costs, :dir, :string, default: 'in'
  end
end
