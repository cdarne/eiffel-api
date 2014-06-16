class SelectValueBuilder < ModelBuilder

  def initialize(question)
    super()
    @question = question
  end

  protected

  def internal_build(params)
  end
end