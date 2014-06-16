class RatingValue < ActiveRecord::Base
  # Associations

  belongs_to :question
  has_many :values, class_name: "RatingValueEntry"

  # Validations

  validates :question_id, presence: true
  validates :min, :max, :step, numericality: true
end
