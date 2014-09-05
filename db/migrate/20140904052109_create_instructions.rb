class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.string :description
      t.integer :exam_id
      t.integer :defined_by

      t.timestamps
    end
  end
end
