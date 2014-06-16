require 'rails_helper'

RSpec.describe SelectValueBuilder do
  let(:survey) { Survey.create!(description: "desc") }
  let(:question) { survey.questions.create!(order: 0, description: "desc", question_type: Question::TYPE[:select]) }

  describe "#build" do
    it "fails when the survey creation fails" do
      expect(question).to receive(:create_select_value!).and_raise(ActiveRecord::RecordInvalid.new(SelectValue.new))
      svb = SelectValueBuilder.new(question)
      svb.build({})
      expect(svb.select_value).to be_nil
      expect(svb.errors).to be_a_kind_of(ActiveModel::Errors)
    end

    [nil, {}, []].each do |values_params|
      it "fails when the params don't contain valid 'values' params (#{values_params.class})" do
        svb = SelectValueBuilder.new(question)
        svb.build({multiple: false, values: values_params})
        expect(svb.errors).to include("Missing or invalid 'values' params")
      end
    end

    it "value build succeeds" do
      svb = SelectValueBuilder.new(question)
      response = svb.build({multiple: false, values: [
          {description: "value #1", score: 1}
      ]})

      expect(response).to be_truthy
      expect(svb.select_value).to be_persisted
      value = svb.select_value.values.first
      expect(value.description).to eq("value #1")
      expect(value.score).to eq(1)
      expect(svb.errors).to be_empty
    end

    it "question build fails" do
      svb = SelectValueBuilder.new(question)
      response = svb.build({multiple: false, values: [
          {description: "value #1"}
      ]})

      expect(response).to be_falsey
      expect(svb.select_value).not_to be_persisted
      expect(svb.select_value.values).to be_empty
      expect(svb.errors).to include(:score)
    end

    it "handles questions order" do
      svb = SelectValueBuilder.new(question)
      svb.build({multiple: false, values: [
          {description: "value #1", score: 1},
          {description: "value #2", score: 2}
      ]})
      expect(svb.select_value.values.first.order).to eq(0)
      expect(svb.select_value.values.last.order).to eq(1)
      expect(svb.select_value.values.last.order).to eq(1)
    end
  end
end