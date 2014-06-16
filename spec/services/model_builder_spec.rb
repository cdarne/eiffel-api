require 'rails_helper'

RSpec.describe ModelBuilder do
  describe "#build" do
    it "raise NotImplementedError when not subclassed" do
      expect { ModelBuilder.new.build({}) }.to raise_error(NotImplementedError)
    end

    context "subclassed" do
      it "calls #internal_build" do
        buidlerClass = Class.new(ModelBuilder) do
          def internal_build(params)
          end
        end

        builder = buidlerClass.new
        expect(builder).to receive(:internal_build).with({test: true})
        response = builder.build({test: true})
        expect(response).to be_truthy
      end

      it "rescues validation errors" do
        buidlerClass = Class.new(ModelBuilder) do
          def internal_build(params)
            Survey.create!
          end
        end

        builder = buidlerClass.new
        response = builder.build({})
        expect(builder.errors).to be_a_kind_of(ActiveModel::Errors)
        expect(response).to be_falsey
      end

      it "rescues validation errors" do
        buidlerClass = Class.new(ModelBuilder) do
          def internal_build(params)
            raise ArgumentError, "invalid"
          end
        end

        builder = buidlerClass.new
        response = builder.build({})
        expect(builder.errors).to eq(["invalid"])
        expect(response).to be_falsey
      end
    end
  end
end