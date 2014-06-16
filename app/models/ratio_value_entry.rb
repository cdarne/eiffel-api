class RatioValueEntry < ActiveRecord::Base
  # Associations

  belongs_to :ratio_value

  # Validations

  validates :ratio_value_id, :description, presence: true
  validates :order, numericality: {only_integer: true, greater_than: 0}
end
