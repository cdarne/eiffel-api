class CreateRatioValues < ActiveRecord::Migration
  def change
    create_table :ratio_values do |t|
      t.references :question, index: true

      t.timestamps
    end

    add_foreign_key :ratio_values, :question, dependent: :delete
  end
end
