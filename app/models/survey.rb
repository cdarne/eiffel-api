class Survey < ActiveRecord::Base
  # Associations

  has_many :questions

  # Validations

  validates :description, presence: true
end
