class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :description, :dependent_question, :question_type

  has_one :select_value
  has_one :rating_value
  has_one :ratio_value

  def include_dependent_question?
    object.dependent_question_id.present?
  end

  def dependent_question
    object.dependent_question.order
  end

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
