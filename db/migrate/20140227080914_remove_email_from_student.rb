class RemoveEmailFromStudent < ActiveRecord::Migration
  def change
    remove_column :students, :email, :string
  end
end
