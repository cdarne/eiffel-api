class QuestionBuilder < ModelBuilder

  def initialize(survey)
    super()
    @survey = survey
  end

  protected

  def internal_build(question_params)
    Question.transaction do
      create_question(question_params)
      check_value_parameters(question_params)
      build_value(question_params)
    end
  end

  private

  def create_question(question_params)
    @question = @survey.questions.create!(question_params)
  end

  def check_value_parameters(question_params)
    case @question.question_type
      when Question::TYPE[:select]
        if !question_params[:select_value].kind_of?(Array) || question_params[:select_value].empty?
          raise ArgumentError, "Missing or invalid 'select_value' params"
        end
      when Question::TYPE[:rating]
        if !question_params[:rating_value].kind_of?(Array) || question_params[:rating_value].empty?
          raise ArgumentError, "Missing or invalid 'rating_value' params"
        end
      when Question::TYPE[:ratio]
        if !question_params[:ratio_value].kind_of?(Array) || question_params[:ratio_value].empty?
          raise ArgumentError, "Missing or invalid 'ratio_value' params"
        end
    end
  end

  def build_value(question_params)
    question_params.each do |question_params|
      qb = QuestionBuilder.new(survey)
      unless qb.build(question_params)
        @errors
      end
    end
  end
end