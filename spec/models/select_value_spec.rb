require 'rails_helper'

RSpec.describe SelectValue, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:question_id) }
  end
end
