require 'rails_helper'

RSpec.describe Answer, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:question_id) }
    it { should validate_presence_of(:user_id) }
  end
end
