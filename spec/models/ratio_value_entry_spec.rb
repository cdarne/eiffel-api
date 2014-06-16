require 'rails_helper'

RSpec.describe RatioValueEntry, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:ratio_value_id) }

    it { should validate_presence_of(:description ) }

    it { should validate_numericality_of(:order).only_integer.is_greater_than(0) }
    it { should_not allow_value(nil).for(:order) }
  end
end
