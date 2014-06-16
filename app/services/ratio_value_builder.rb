class RatioValueBuilder < ModelBuilder

  attr_reader :ratio_value

  def initialize(question)
    super()
    @question = question
  end

  protected

  def internal_build(ratio_params)
    RatioValue.transaction do
      create_ratio_value(ratio_params)
      check_ratio_values(ratio_params[:values])
      build_ratio_value_entries(ratio_params[:values])
    end
  end

  private

  def create_ratio_value(ratio_params)
    @ratio_value = @question.create_ratio_value!
  end

  def check_ratio_values(values)
    if !values.kind_of?(Array) || values.empty?
      raise ArgumentError, "Missing or invalid 'values' params"
    end
  end

  def build_ratio_value_entries(values)
    order = 0
    values.each do |value|
      @ratio_value.values.create!(description: value, order: order)
      order += 1
    end
  end
end