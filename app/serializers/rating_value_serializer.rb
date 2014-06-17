class RatingValueSerializer < ActiveModel::Serializer
  attributes :min, :max, :step, :values

  def values
    object.values.pluck(:description)
  end
end
