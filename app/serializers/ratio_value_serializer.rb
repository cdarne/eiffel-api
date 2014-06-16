class RatioValueSerializer < ActiveModel::Serializer
  attributes :values

  def values
    object.values.order(:order).pluck(:description)
  end
end
