class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
      t.integer :department_id
      t.string :designation
      t.string :email

      t.timestamps
    end
  end
end
