class SurveySerializer < ActiveModel::Serializer
  attributes :id, :description
  has_many :questions
end
