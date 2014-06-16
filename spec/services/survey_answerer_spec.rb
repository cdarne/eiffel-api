require 'rails_helper'

RSpec.describe SurveyAnswerer do
  let!(:survey) { Survey.create!(description: "desc") }
  let!(:question) { survey.questions.create!(order: 0, description: "desc", question_type: Question::TYPE[:boolean]) }

  describe "#answer" do
    it "fails when the user id is not provided" do
      sa = SurveyAnswerer.new(survey)
      response = sa.answer({})
      expect(response).to be_falsey
      expect(sa.errors).to include("Missing 'user_id' parameter")
    end

    [nil, {}, []].each do |value_params|
      it "fails when the params don't contain valid 'values' params (#{value_params.class})" do
        sa = SurveyAnswerer.new(survey)
        response = sa.answer({user_id: "42", values: value_params})
        expect(response).to be_falsey
        expect(sa.errors).to include("Missing or invalid 'values' params")
      end
    end

    it "fails when a validation error is raised" do
      answer = Answer.new
      answer.valid?
      answer_strategy = instance_double("BooleanAnswerStrategy")
      expect(answer_strategy).to receive(:answer).with("42", "plop").and_raise(ActiveRecord::RecordInvalid.new(answer))
      expect(AnswerStrategy).to receive(:factory).and_return(answer_strategy)

      sa = SurveyAnswerer.new(survey)
      response = sa.answer({user_id: "42", values: ["plop"]})
      expect(response).to be_falsey
      expect(sa.errors).to include(:user_id)
    end

    it "fails when a validation error is raised" do
      answer_strategy = instance_double("BooleanAnswerStrategy")
      expect(answer_strategy).to receive(:answer).with("42", "plop")
      expect(AnswerStrategy).to receive(:factory).and_return(answer_strategy)

      sa = SurveyAnswerer.new(survey)
      response = sa.answer({user_id: "42", values: ["plop"]})
      expect(response).to be_truthy
      expect(sa.errors).to be_empty
    end
  end
end