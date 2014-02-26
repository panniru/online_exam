class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.string :subject
      t.integer :semister
      t.string :exam
      t.integer :course_id
      t.float :duration
      t.integer :no_of_questions
      t.float :negative_mark
      t.float :pass_criteria_1
      t.text :pass_text_1
      t.float :pass_criteria_2
      t.string :pass_text_2
      t.float :pass_criteria_3
      t.string :pass_text_3
      t.float :pass_criteria_4
      t.string :pass_text_4
      t.integer :multiple_choice
      t.integer :fill_in_blanks

      t.timestamps
    end
  end
end
