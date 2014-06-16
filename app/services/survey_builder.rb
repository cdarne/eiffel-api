class SurveyBuilder < ModelBuilder

  attr_reader :survey

  protected

  def internal_build(survey_params)
    Survey.transaction do
      create_survey(survey_params)
      check_questions_parameter(survey_params[:questions])
      build_questions(survey_params[:questions])
    end
  end

  private

  def create_survey(survey_params)
    @survey = Survey.create!(filter_survey_params(survey_params))
  end

  def filter_survey_params(params)
    params.select { |k, _| k == "description" }
  end

  def check_questions_parameter(questions_params)
    if !questions_params.kind_of?(Array) || questions_params.empty?
      raise ArgumentError, "Missing or invalid 'questions' params"
    end
  end

  def build_questions(questions_params)
    order = 0
    questions_params.each do |question_params|
      question_params[:order] = order
      qb = QuestionBuilder.new(@survey)
      unless qb.build(question_params)
        @errors = qb.errors
        raise ActiveRecord::Rollback
      end
      order += 1
    end
  end
end