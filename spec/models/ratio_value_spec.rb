require 'rails_helper'

RSpec.describe RatioValue, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:question_id) }
  end
end
