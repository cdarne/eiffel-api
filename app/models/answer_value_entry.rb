class AnswerValueEntry < ActiveRecord::Base
  # Associations

  belongs_to :answer

  # Validations

  validates :answer_id, presence: true

  # value will be saved to the database as an object, and retrieved as the same object
  serialize :value
end
