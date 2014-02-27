class RemoveEmailFromFaculty < ActiveRecord::Migration
  def change
    remove_column :faculties, :email, :string
  end
end
