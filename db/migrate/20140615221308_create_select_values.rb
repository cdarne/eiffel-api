class CreateSelectValues < ActiveRecord::Migration
  def change
    create_table :select_values do |t|
      t.references :question, index: true
      t.boolean :multiple, default: false

      t.timestamps
    end

    add_foreign_key :select_values, :questions, dependent: :delete
  end
end
