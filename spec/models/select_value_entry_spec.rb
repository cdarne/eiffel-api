require 'rails_helper'

RSpec.describe SelectValueEntry, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:select_value_id) }

    it { should validate_presence_of(:description) }

    it { should validate_numericality_of(:order).only_integer.is_greater_than(0) }
    it { should_not allow_value(nil).for(:order) }

    it { should validate_numericality_of(:score).only_integer.is_greater_than_or_equal_to(0) }
    it { should_not allow_value(nil).for(:score) }
  end
end
