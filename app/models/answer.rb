class Answer < ActiveRecord::Base
  # Associations

  belongs_to :question

  # Validations

  validates :user_id, :question_id, presence: true
end
