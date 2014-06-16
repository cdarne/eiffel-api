require 'rails_helper'

RSpec.describe SurveyBuilder do
  describe "#build" do
    it "fails when the survey creation fails" do
      sb = SurveyBuilder.new
      sb.build({})
      expect(sb.survey).to be_nil
      expect(sb.errors).to include(:description)
    end

    [nil, {}, []].each do |questions_params|
      it "fails when the params don't contain valid 'questions' params (#{questions_params.class})" do
        sb = SurveyBuilder.new
        sb.build({description: "desc", questions: questions_params})
        expect(sb.errors).to include("Missing or invalid 'questions' params")
      end
    end

    it "question build succeeds" do
      question_builder = instance_double("QuestionBuilder")
      expect(QuestionBuilder).to receive(:new).and_return(question_builder)
      expect(question_builder).to receive(:build).and_return(true)
      sb = SurveyBuilder.new
      response = sb.build({description: "desc", questions: [{}]})
      expect(response).to be_truthy
      expect(sb.survey).to be_persisted
      expect(sb.errors).to be_empty
    end

    it "question build fails" do
      question_builder = instance_double("QuestionBuilder")
      expect(QuestionBuilder).to receive(:new).and_return(question_builder)
      expect(question_builder).to receive(:build).and_return(false)
      expect(question_builder).to receive(:errors).and_return(["invalid"])
      sb = SurveyBuilder.new
      response = sb.build({description: "desc", questions: [{}]})
      expect(response).to be_falsey
      expect(sb.survey).not_to be_persisted
      expect(sb.errors).to eq(["invalid"])
    end

    it "handles questions order" do
      # 1st question builder
      question_builder = instance_double("QuestionBuilder")
      expect(QuestionBuilder).to receive(:new).and_return(question_builder)
      expect(question_builder).to receive(:build).with(description: "question #1", order: 1).and_return(true)

      # 2nd question builder
      question_builder = instance_double("QuestionBuilder")
      expect(QuestionBuilder).to receive(:new).and_return(question_builder)
      expect(question_builder).to receive(:build).with(description: "question #2", order: 2).and_return(true)

      sb = SurveyBuilder.new
      sb.build({description: "survey desc", questions: [{description: "question #1"}, {description: "question #2"}]})
    end
  end
end