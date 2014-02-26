class RemoveColumnFromFaculty < ActiveRecord::Migration
  def change
    remove_column :faculties, :department_id, :integer
  end
end
