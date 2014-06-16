class CreateRatioValueEntries < ActiveRecord::Migration
  def change
    create_table :ratio_value_entries do |t|
      t.references :ratio_value, index: true
      t.integer :order
      t.string :description

      t.timestamps
    end

    add_foreign_key :ratio_value_entries, :ratio_values, dependent: :delete
  end
end
