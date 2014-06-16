class Question < ActiveRecord::Base
  # Constants

  TYPE = {
      boolean: "boolean", # yes/no response
      select: "select", # select a response in a list
      input: "input", # direct input of the response
      rating: "rating", # rate on a scale
      ratio: "ratio" # balance ratios between different values
  }

  # Associations

  belongs_to :survey
  belongs_to :dependent_question, class_name: "Question"

  # Composite values
  has_one :select_value
  has_one :rating_value
  has_one :ratio_value

  # Validations

  validates :question_type, inclusion: TYPE.values
  validates :order, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :weight, numericality: {only_integer: true, greater_than: 0}
  validates :survey_id, :description, presence: true
end
