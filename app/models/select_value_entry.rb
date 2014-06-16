class SelectValueEntry < ActiveRecord::Base
  # Associations

  belongs_to :select_value

  # Validations

  validates :select_value_id, :description, presence: true
  validates :order, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :score, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
