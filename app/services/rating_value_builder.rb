class RatingValueBuilder < ModelBuilder

  attr_reader :rating_value

  def initialize(question)
    super()
    @question = question
  end

  protected

  def internal_build(rating_params)
    RatingValue.transaction do
      create_rating_value(rating_params)
      check_rating_values(rating_params[:values])
      build_rating_value_entries(rating_params[:values])
    end
  end

  private

  def create_rating_value(rating_params)
    @rating_value = @question.create_rating_value!(filter_rating_value_params(rating_params))
  end

  def filter_rating_value_params(rating_params)
    rating_params.select { |k, _| %w(min max step).include?(k) }
  end

  def check_rating_values(values)
    if !values.kind_of?(Array) || values.empty?
      raise ArgumentError, "Missing or invalid 'values' params"
    end
  end

  def build_rating_value_entries(values)
    order = 0
    values.each do |value|
      @rating_value.values.create!(description: value, order: order)
      order += 1
    end
  end
end