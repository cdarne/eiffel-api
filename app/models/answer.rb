class Answer < ActiveRecord::Base
  # Associations

  belongs_to :question
  has_many :values, class_name: "AnswerValueEntry"

  # Validations

  validates :user_id, :question_id, presence: true
end
