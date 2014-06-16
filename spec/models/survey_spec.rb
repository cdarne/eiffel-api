require 'rails_helper'

RSpec.describe Survey, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:description) }
  end
end
