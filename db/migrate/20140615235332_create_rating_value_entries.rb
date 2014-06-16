class CreateRatingValueEntries < ActiveRecord::Migration
  def change
    create_table :rating_value_entries do |t|
      t.references :rating_value, index: true
      t.integer :order
      t.string :description

      t.timestamps
    end

    add_foreign_key :rating_value_entries, :rating_values, dependent: :delete
  end
end
