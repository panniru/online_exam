class AddResourceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :resource_id, :integer
  end
end
