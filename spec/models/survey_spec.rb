require 'rails_helper'

RSpec.describe Survey, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:description) }
  end

  describe ".cache_key" do
    it "changes when the table changes" do
      # Insert
      expect { Survey.create!(description: "test") }.to change { Survey.cache_key }

      # Update
      expect { Survey.last.update(description: "new value", updated_at: (Time.current + 1)) }.to change { Survey.cache_key }

      # Select
      expect { Survey.last }.not_to change { Survey.cache_key }

      # Delete
      expect { Survey.last.destroy }.to change { Survey.cache_key }
    end
  end
end
