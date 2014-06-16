class SelectValueBuilder < ModelBuilder

  attr_reader :select_value

  def initialize(question)
    super()
    @question = question
  end

  protected

  def internal_build(select_params)
    SelectValue.transaction do
      create_select_value(select_params)
      check_select_values(select_params[:values])
      build_select_value_entries(select_params[:values])
    end
  end

  private

  def create_select_value(select_params)
    @select_value = @question.create_select_value!(filter_select_value_params(select_params))
  end

  # Cleans up params to avoid security breach
  def filter_select_value_params(select_params)
    select_params.select { |k, _| %w(multiple).include?(k) }
  end

  def check_select_values(values)
    if !values.kind_of?(Array) || values.empty?
      raise ArgumentError, "Missing or invalid 'values' params"
    end
  end

  def build_select_value_entries(values)
    order = 0
    values.each do |value|
      @select_value.values.create!(value.merge(order: order))
      order += 1
    end
  end
end