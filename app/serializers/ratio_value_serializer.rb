class RatioValueSerializer < ActiveModel::Serializer
  attributes :values

  def values
    object.values.pluck(:description)
  end
end
