class AnswerStrategy
  def initialize(question)
    @question = question
  end

  def answer(user_id, value)
    raise NotImplementedError
  end

  def self.factory(question)
    case question.question_type
      when Question::TYPE[:boolean]
        BooleanAnswerStrategy.new(question)
      when Question::TYPE[:input]
        InputAnswerStrategy.new(question)
      when Question::TYPE[:select]
        SelectAnswerStrategy.new(question)
      when Question::TYPE[:rating]
        RatingAnswerStrategy.new(question)
      when Question::TYPE[:ratio]
        RatioAnswerStrategy.new(question)
    end
  end
end

class BooleanAnswerStrategy < AnswerStrategy

  def answer(user_id, value)
    # value must be explicitly true or false
    raise ArgumentError, "Expecting boolean value" unless [TrueClass, FalseClass].include?(value.class)
    answer = @question.answers.create!(user_id: user_id)
    answer.values.create!(value: value)
  end
end

class SelectAnswerStrategy < AnswerStrategy

  def answer(user_id, value)
    # value must be an Int between 0 and the values count (excluded)
    if !value.kind_of?(Fixnum) || !(0...@question.select_value.values.count).include?(value)
      raise ArgumentError, "Expecting a value in range"
    end
    answer = @question.answers.create!(user_id: user_id)
    answer.values.create!(value: value)
  end
end

class InputAnswerStrategy < AnswerStrategy

  def answer(user_id, value)
    raise ArgumentError, "Expecting non blank value" if value.blank?
    answer = @question.answers.create!(user_id: user_id)
    answer.values.create!(value: value)
  end
end

class RatingAnswerStrategy < AnswerStrategy

  def answer(user_id, values)
    rating_value = @question.rating_value
    if !values.kind_of?(Array) ||
        values.size != rating_value.values.count ||
        !values.all? { |v| (rating_value.min..rating_value.max).include?(v) } # All values must be between min and max
      raise ArgumentError, "Expecting an array of rating within the limits"
    end

    answer = @question.answers.create!(user_id: user_id)
    values.each do |v|
      answer.values.create!(value: v)
    end
  end
end

class RatioAnswerStrategy < AnswerStrategy

  def answer(user_id, values)
    if !values.kind_of?(Array) ||
        values.size != @question.ratio_value.values.count ||
        values.inject(:+) != 100 # the sum of all value must be 100%
      raise ArgumentError, "Expecting an array of ratios with a sum equal to 100%"
    end

    answer = @question.answers.create!(user_id: user_id)
    values.each do |v|
      answer.values.create!(value: v)
    end
  end
end


