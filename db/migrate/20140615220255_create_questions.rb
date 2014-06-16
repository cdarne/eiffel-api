class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :order
      t.text :description
      t.integer :weight
      t.references :survey, index: true
      t.references :dependent_question, index: true
      t.string :question_type

      t.timestamps
    end

    add_foreign_key :questions, :surveys, dependent: :delete
    add_foreign_key :questions, :questions, column: :dependent_question_id, dependent: :nullify
  end
end
