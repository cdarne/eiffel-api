class ModelBuilder
  attr_reader :errors

  def initialize
    @errors = []
  end

  def build(params)
    internal_build(params)
  rescue ActiveRecord::RecordInvalid => e
    @errors = e.record.errors
  rescue ArgumentError => e
    @errors = [e.message]
  ensure
    @errors.empty?
  end

  BuildError = Class.new(StandardError)

  protected

  def internal_build(params)
    raise NotImplementedError
  end
end