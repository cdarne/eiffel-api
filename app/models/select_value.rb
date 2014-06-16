class SelectValue < ActiveRecord::Base
  # Associations

  belongs_to :question
  has_many :values, class_name: "SelectValueEntry"

  # Validations

  validates :question_id, presence: true
end
