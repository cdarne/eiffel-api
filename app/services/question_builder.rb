class QuestionBuilder < ModelBuilder

  attr_reader :question

  def initialize(survey)
    super()
    @survey = survey
  end

  protected

  def internal_build(question_params)
    Question.transaction do
      create_question(question_params)
      select_value_build_strategy
      check_value_parameters(question_params)
      build_value(question_params)
    end
  end

  private

  def create_question(question_params)
    if question_params[:dependent_question]
      dependent_question = @survey.questions.find_by_order(question_params[:dependent_question])
      raise ArgumentError, "Dependent question ##{question_params[:dependent_question]} no found" unless dependent_question
      question_params[:dependent_question_id] = dependent_question.id
    end
    @question = @survey.questions.create!(filter_question_params(question_params))
  end

  def filter_question_params(params)
    params.select { |k, _| %w(description weight question_type order dependent_question_id).include?(k) }
  end

  def select_value_build_strategy
    klass = VALUE_BUILD_STRATEGY[@question.question_type] || VALUE_BUILD_STRATEGY["null"]
    @value_build_strategy = klass.new
  end

  def check_value_parameters(question_params)
    @value_build_strategy.check_parameters(question_params)
  end

  def build_value(question_params)
    unless @value_build_strategy.build(@question, question_params)
      @errors = @value_build_strategy.builder.errors
      raise ActiveRecord::Rollback
    end
  end

  # We dynamically build strategy classes, for the types of value which need special build behaviour.
  # The advantage is that the strategy can be set at runtime and provide a separation of concerns.
  # The QuestionBuilder will delegate value parameter check and value building to the strategy.
  VALUE_BUILD_STRATEGY = {}
  Question::TYPE.values_at(:select, :rating, :ratio).each do |type|
    value_key = "#{type}_value".to_sym
    value_builder_class = "#{type.capitalize}ValueBuilder"
    strategy_class = Class.new
    VALUE_BUILD_STRATEGY[type] = strategy_class

    strategy_class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      attr_reader :builder

      def check_parameters(question_params)
        if !question_params[:#{value_key}].kind_of?(Hash) || question_params[:#{value_key}].empty?
          raise ArgumentError, "Missing or invalid '#{value_key}' params"
        end
      end

      def build(question, question_params)
        params = question_params[:#{value_key}]
        @builder = #{value_builder_class}.new(question)
        @builder.build(params)
      end
    RUBY
  end

  # Null value build strategy
  # It does nothing, used when no special build is required for a value type
  VALUE_BUILD_STRATEGY["null"] = Class.new do
    def check_parameters(question_params)
    end

    def build(question, question_params)
      true
    end
  end
end