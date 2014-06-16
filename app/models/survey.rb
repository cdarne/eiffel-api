class Survey < ActiveRecord::Base
  # Associations

  has_many :questions

  # Validations

  validates :description, presence: true

  # Utils

  # Generates a cache key which changes when a record is created, updated or destroyed
  def self.cache_key
    scope = where(nil)
    Digest::MD5.hexdigest "#{scope.maximum(:updated_at).try(:to_i)}-#{scope.count}"
  end
end
