class RatingValueSerializer < ActiveModel::Serializer
  attributes :min, :max, :step, :values

  def values
    object.values.order(:order).pluck(:description)
  end
end
