require 'rails_helper'

RSpec.describe RatingValue, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:question_id) }

    it { should validate_numericality_of(:min) }
    it { should validate_numericality_of(:max) }
    it { should validate_numericality_of(:step) }
  end
end
