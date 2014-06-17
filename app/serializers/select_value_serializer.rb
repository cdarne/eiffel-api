class SelectValueSerializer < ActiveModel::Serializer
  attributes :multiple, :values

  def values
    object.values.pluck(:description)
  end
end
