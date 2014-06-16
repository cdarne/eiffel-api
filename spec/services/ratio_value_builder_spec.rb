require 'rails_helper'

RSpec.describe RatioValueBuilder do
  let(:survey) { Survey.create!(description: "desc") }
  let(:question) { survey.questions.create!(order: 0, description: "desc", question_type: Question::TYPE[:ratio]) }

  describe "#build" do
    it "fails when the survey creation fails" do
      expect(question).to receive(:create_ratio_value!).and_raise(ActiveRecord::RecordInvalid.new(RatioValue.new))
      svb = RatioValueBuilder.new(question)
      svb.build({})
      expect(svb.ratio_value).to be_nil
      expect(svb.errors).to be_a_kind_of(ActiveModel::Errors)
    end

    [nil, {}, []].each do |values_params|
      it "fails when the params don't contain valid 'values' params (#{values_params.class})" do
        svb = RatioValueBuilder.new(question)
        svb.build(values: values_params)
        expect(svb.errors).to include("Missing or invalid 'values' params")
      end
    end

    it "value build succeeds" do
      svb = RatioValueBuilder.new(question)
      response = svb.build(values: ["value #1"])

      expect(response).to be_truthy
      expect(svb.ratio_value).to be_persisted
      value = svb.ratio_value.values.first
      expect(value.description).to eq("value #1")
      expect(svb.errors).to be_empty
    end

    it "question build fails" do
      svb = RatioValueBuilder.new(question)
      response = svb.build(values: [nil])

      expect(response).to be_falsey
      expect(svb.ratio_value).not_to be_persisted
      expect(svb.ratio_value.values).to be_empty
      expect(svb.errors).to include(:description)
    end

    it "handles questions order" do
      svb = RatioValueBuilder.new(question)
      svb.build(values: ["value #1", "value #2"])
      expect(svb.ratio_value.values.first.order).to eq(0)
      expect(svb.ratio_value.values.last.order).to eq(1)
      expect(svb.ratio_value.values.last.order).to eq(1)
    end
  end
end