require 'rails_helper'

RSpec.describe RatingValueBuilder do
  let(:survey) { Survey.create!(description: "desc") }
  let(:question) { survey.questions.create!(order: 0, description: "desc", question_type: Question::TYPE[:rating]) }
  let(:valid_params) { {min: 1, max: 5, step: 5} }

  describe "#build" do
    it "fails when the survey creation fails" do
      expect(question).to receive(:create_rating_value!).and_raise(ActiveRecord::RecordInvalid.new(RatingValue.new))
      svb = RatingValueBuilder.new(question)
      svb.build({})
      expect(svb.rating_value).to be_nil
      expect(svb.errors).to be_a_kind_of(ActiveModel::Errors)
    end

    [nil, {}, []].each do |values_params|
      it "fails when the params don't contain valid 'values' params (#{values_params.class})" do
        svb = RatingValueBuilder.new(question)
        svb.build(valid_params.merge(values: values_params))
        expect(svb.errors).to include("Missing or invalid 'values' params")
      end
    end

    it "value build succeeds" do
      svb = RatingValueBuilder.new(question)
      response = svb.build(valid_params.merge(values: ["value #1"]))

      expect(response).to be_truthy
      expect(svb.rating_value).to be_persisted
      value = svb.rating_value.values.first
      expect(value.description).to eq("value #1")
      expect(svb.errors).to be_empty
    end

    it "question build fails" do
      svb = RatingValueBuilder.new(question)
      response = svb.build(valid_params.merge(values: [nil]))

      expect(response).to be_falsey
      expect(svb.rating_value).not_to be_persisted
      expect(svb.rating_value.values).to be_empty
      expect(svb.errors).to include(:description)
    end

    it "handles questions order" do
      svb = RatingValueBuilder.new(question)
      svb.build(valid_params.merge(values: ["value #1", "value #2"]))
      expect(svb.rating_value.values.first.order).to eq(0)
      expect(svb.rating_value.values.last.order).to eq(1)
      expect(svb.rating_value.values.last.order).to eq(1)
    end
  end
end