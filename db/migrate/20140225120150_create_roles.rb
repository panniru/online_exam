class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :role
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
