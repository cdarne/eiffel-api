# Process params to create answers for a survey
class SurveyAnswerer
  attr_reader :errors

  def initialize(survey)
    @survey = survey
    @user_id = nil
    @errors = []
  end

  def answer(params)
    begin
      get_user_id(params)
      check_values(params[:values])
      process_values(params[:values])
    rescue ActiveRecord::RecordInvalid => e
      @errors = e.record.errors
    rescue ArgumentError => e
      @errors = [e.message]
    end
    @errors.empty?
  end

  protected

  def get_user_id(params)
    @user_id = params[:user_id]
    raise ArgumentError, "Missing 'user_id' parameter" if @user_id.blank?
  end

  def check_values(values)
    if !values.kind_of?(Array) || values.empty?
      raise ArgumentError, "Missing or invalid 'values' params"
    end
  end

  def process_values(values)
    @survey.questions.each_with_index do |q, i|
      answer_strategy = AnswerStrategy.factory(q)
      answer_strategy.answer(@user_id, values[i])
    end
  end
end



