class AddExtraCriteriasToExams < ActiveRecord::Migration
  def change
    add_column :exams, :pass_criteria_5, :float
    add_column :exams, :pass_text_5, :string
    add_column :exams, :pass_criteria_6, :float
    add_column :exams, :pass_text_6, :string
  end
end
