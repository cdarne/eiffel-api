class SelectValueSerializer < ActiveModel::Serializer
  attributes :multiple, :values

  def values
    object.values.order(:order).pluck(:description)
  end
end
