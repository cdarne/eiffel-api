class RatioValue < ActiveRecord::Base
  # Associations

  belongs_to :question
  has_many :values, class_name: "RatioValueEntry"

  # Validations

  validates :question_id, presence: true
end
