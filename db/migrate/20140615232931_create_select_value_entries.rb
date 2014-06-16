class CreateSelectValueEntries < ActiveRecord::Migration
  def change
    create_table :select_value_entries do |t|
      t.references :select_value, index: true
      t.integer :order
      t.integer :score
      t.string :description

      t.timestamps
    end

    add_foreign_key :select_value_entries, :select_values, dependent: :delete
  end
end
