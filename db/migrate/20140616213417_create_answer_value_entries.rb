class CreateAnswerValueEntries < ActiveRecord::Migration
  def change
    create_table :answer_value_entries do |t|
      t.references :answer, index: true
      t.text :value

      t.timestamps
    end
    add_foreign_key :answer_value_entries, :answers, dependent: :delete
  end
end
