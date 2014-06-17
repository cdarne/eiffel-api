class RatingValueEntry < ActiveRecord::Base
  # Associations

  belongs_to :rating_value

  # Validations

  validates :rating_value_id, :description, presence: true
  validates :order, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  default_scope { order(:order) }
end
