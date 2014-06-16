# Abstract class used to define how to build survey/question/value models
class ModelBuilder
  attr_reader :errors

  def initialize
    @errors = []
  end

  def build(params)
    params = HashWithIndifferentAccess.new(params)
    begin
      internal_build(params)
    rescue ActiveRecord::RecordInvalid => e
      @errors = e.record.errors
    rescue ArgumentError => e
      @errors = [e.message]
    end
    @errors.empty?
  end

  protected

  def internal_build(params)
    raise NotImplementedError
  end
end