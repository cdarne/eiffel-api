class CreateRatingValues < ActiveRecord::Migration
  def change
    create_table :rating_values do |t|
      t.references :question, index: true
      t.integer :min
      t.integer :max
      t.integer :step

      t.timestamps
    end

    add_foreign_key :rating_values, :questions, dependent: :delete
  end
end
