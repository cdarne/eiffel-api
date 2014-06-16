class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, index: true
      t.string :user_id

      t.timestamps
    end

    add_foreign_key :answers, :questions, dependent: :delete
  end
end
