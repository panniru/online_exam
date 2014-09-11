class AddDefaultValuesToQuestionCountExam < ActiveRecord::Migration
  def change
    change_column :exams, :multiple_choice, :integer, :default => 0
    change_column :exams, :fill_in_blanks, :integer, :default => 0
  end
end
