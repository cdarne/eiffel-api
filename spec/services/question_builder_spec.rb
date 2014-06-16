require 'rails_helper'

RSpec.describe QuestionBuilder do
  describe "#build" do
    let(:survey) { Survey.create!(description: "desc") }
    let(:valid_params) {
      {description: "test question", order: 1, question_type: Question::TYPE.values.first}
    }

    it "fails when the survey creation fails" do
      qb = QuestionBuilder.new(survey)
      qb.build({})
      expect(qb.question).to be_nil
      expect(qb.errors).to include(:description)
    end

    it "fails when the dependent question is provided but not found" do
      qb = QuestionBuilder.new(survey)
      params = valid_params
      params[:dependent_question] = 0
      params[:order] = 1
      qb.build(valid_params)
      expect(qb.question).to be_nil
      expect(qb.errors).to include("Dependent question #0 no found")
    end

    %w(boolean input).each do |value_type|
      describe "#{value_type} question" do
        it "succeeds" do
          qb = QuestionBuilder.new(survey)
          params = valid_params
          params[:question_type] = value_type
          response = qb.build(params)
          expect(response).to be_truthy
          expect(qb.question).to be_persisted
          expect(qb.question.survey).to eq(survey)
          expect(qb.errors).to be_empty
        end
      end
    end


    %w(select rating ratio).each do |value_type|
      builder_class_name = "#{value_type.capitalize}ValueBuilder"
      builder_class = builder_class_name.constantize

      describe "#{value_type} question" do

        [nil, {}, []].each do |value_params|
          it "fails when the params don't contain valid '#{value_type}_value' params (#{value_params.class})" do
            qb = QuestionBuilder.new(survey)
            params = valid_params
            params[:question_type] = value_type
            params[:"#{value_type}_value"] = value_params
            qb.build(params)
            expect(qb.errors).to include("Missing or invalid '#{value_type}_value' params")
          end
        end

        it "fails when value build fails" do
          qb = QuestionBuilder.new(survey)
          params = valid_params
          params[:question_type] = value_type
          params[:"#{value_type}_value"] = {test: true}

          builder = instance_double(builder_class_name)
          expect(builder_class).to receive(:new).and_return(builder)
          expect(builder).to receive(:build).and_return(false)
          expect(builder).to receive(:errors).and_return(["invalid"])

          response = qb.build(params)

          expect(response).to be_falsey
          expect(qb.question).not_to be_persisted
          expect(qb.errors).to eq(["invalid"])
        end

        it "succeeds" do
          qb = QuestionBuilder.new(survey)
          params = valid_params
          params[:question_type] = value_type
          params[:"#{value_type}_value"] = {test: true}

          builder = instance_double(builder_class_name)
          expect(builder_class).to receive(:new).and_return(builder)
          expect(builder).to receive(:build).and_return(true)

          response = qb.build(params)

          expect(response).to be_truthy
          expect(qb.question).to be_persisted
          expect(qb.question.survey).to eq(survey)
          expect(qb.errors).to be_empty
        end
      end
    end
  end
end