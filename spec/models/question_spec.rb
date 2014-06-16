require 'rails_helper'

RSpec.describe Question, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:survey_id) }

    it { should validate_presence_of(:description) }

    it { should validate_numericality_of(:order).only_integer.is_greater_than(0) }
    it { should_not allow_value(nil).for(:order) }

    it { should validate_numericality_of(:weight).only_integer.is_greater_than(0) }
    it { should_not allow_value(nil).for(:weight) }

    it { should ensure_inclusion_of(:question_type).in_array(Question::TYPE.values) }
    it { should_not allow_value(nil).for(:question_type) }
  end
end
