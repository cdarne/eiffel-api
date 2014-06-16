class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :description, :question_type

  has_one :select_value
  has_one :rating_value
  has_one :ratio_value

  def include_select_value?
    object.question_type == Question::TYPE[:select]
  end

  def include_rating_value?
    object.question_type == Question::TYPE[:rating]
  end

  def include_ratio_value?
    object.question_type == Question::TYPE[:ratio]
  end
end
