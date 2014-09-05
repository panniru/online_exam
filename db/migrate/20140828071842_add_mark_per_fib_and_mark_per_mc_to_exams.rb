class AddMarkPerFibAndMarkPerMcToExams < ActiveRecord::Migration
  def change
    add_column :exams, :mark_per_fib, :float
    add_column :exams, :mark_per_mc, :float
  end
end
