class CreateFacultyCourses < ActiveRecord::Migration
  def change
    create_table :faculty_courses do |t|
      t.belongs_to :course
      t.belongs_to :faculty

      t.timestamps
    end
  end
end
