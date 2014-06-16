require 'rails_helper'

RSpec.describe AnswerStrategy do
  let!(:survey) { Survey.create!(description: "desc") }

  def question(type)
    survey.questions.create!(order: 0, description: "desc", question_type: type)
  end

  describe "#answer" do
    it "raise NotImplementedError when not subclassed" do
      expect { AnswerStrategy.new({}).answer("42", {}) }.to raise_error(NotImplementedError)
    end

    context BooleanAnswerStrategy do
      ["true", nil, "", 1].each do |wrong_value|
        it "fails for '#{wrong_value.inspect}'" do
          s = BooleanAnswerStrategy.new(question("boolean"))
          expect { s.answer(42, wrong_value) }.to raise_error(ArgumentError, "Expecting boolean value")
        end
      end

      [true, false].each do |good_value|
        it "succeeds for '#{good_value.inspect}'" do
          q = question("boolean")
          s = BooleanAnswerStrategy.new(q)
          s.answer(42, good_value)
          expect(q.answers.count).to eq(1)
          expect(q.answers.first.values.count).to eq(1)
          expect(q.answers.first.values.first.value).to eq(good_value)
        end
      end
    end

    context SelectAnswerStrategy do
      ["0", nil, 2].each do |wrong_value|
        it "fails for '#{wrong_value.inspect}'" do
          q = question("select")
          sv = q.create_select_value!(multiple: false)
          sv.values.create!(order: 0, description: "desc", score: 1)
          sv.values.create!(order: 1, description: "desc", score: 2)

          s = SelectAnswerStrategy.new(q)
          expect { s.answer(42, wrong_value) }.to raise_error(ArgumentError, "Expecting a value in range")
        end
      end

      [0, 1].each do |good_value|
        it "succeeds for '#{good_value.inspect}'" do
          q = question("select")
          sv = q.create_select_value!(multiple: false)
          sv.values.create!(order: 0, description: "desc", score: 1)
          sv.values.create!(order: 1, description: "desc", score: 2)

          s = SelectAnswerStrategy.new(q)
          s.answer(42, good_value)
          expect(q.answers.count).to eq(1)
          expect(q.answers.first.values.count).to eq(1)
          expect(q.answers.first.values.first.value).to eq(good_value)
        end
      end
    end

    context InputAnswerStrategy do
      ["", nil].each do |wrong_value|
        it "fails for '#{wrong_value.inspect}'" do
          s = InputAnswerStrategy.new(question("input"))
          expect { s.answer(42, wrong_value) }.to raise_error(ArgumentError, "Expecting non blank value")
        end
      end

      ["lol", 42].each do |good_value|
        it "succeeds for '#{good_value.inspect}'" do
          q = question("input")
          s = InputAnswerStrategy.new(q)
          s.answer(42, good_value)
          expect(q.answers.count).to eq(1)
          expect(q.answers.first.values.count).to eq(1)
          expect(q.answers.first.values.first.value).to eq(good_value)
        end
      end
    end

    context RatingAnswerStrategy do
      ["", [1], [1, 6], [0, 3], [1, 1, 1]].each do |wrong_value|
        it "fails for '#{wrong_value.inspect}'" do
          q = question("rating")
          rv = q.create_rating_value(min: 1, max: 5, step: 1)
          rv.values.create!(order: 0, description: "desc")
          rv.values.create!(order: 1, description: "desc")

          s = RatingAnswerStrategy.new(q)
          expect { s.answer(42, wrong_value) }.to raise_error(ArgumentError, "Expecting an array of rating within the limits")
        end
      end

      [[1, 5]].each do |good_value|
        it "succeeds for '#{good_value.inspect}'" do
          q = question("rating")
          rv = q.create_rating_value(min: 1, max: 5, step: 1)
          rv.values.create!(order: 0, description: "desc")
          rv.values.create!(order: 1, description: "desc")

          s = RatingAnswerStrategy.new(q)
          s.answer(42, good_value)
          expect(q.answers.count).to eq(1)
          expect(q.answers.first.values.count).to eq(2)
          expect(q.answers.first.values.first.value).to eq(good_value.first)
          expect(q.answers.first.values.last.value).to eq(good_value.last)
        end
      end
    end

    context RatioAnswerStrategy do
      ["", [15], [75, 20], [50, 25, 25]].each do |wrong_value|
        it "fails for '#{wrong_value.inspect}'" do
          q = question("ratio")
          rav = q.create_ratio_value
          rav.values.create!(order: 0, description: "desc")
          rav.values.create!(order: 1, description: "desc")

          s = RatioAnswerStrategy.new(q)
          expect { s.answer(42, wrong_value) }.to raise_error(ArgumentError, "Expecting an array of ratios with a sum equal to 100%")
        end
      end

      [[75, 25]].each do |good_value|
        it "succeeds for '#{good_value.inspect}'" do
          q = question("ratio")
          rav = q.create_ratio_value
          rav.values.create!(order: 0, description: "desc")
          rav.values.create!(order: 1, description: "desc")

          s = RatioAnswerStrategy.new(q)
          s.answer(42, good_value)
          expect(q.answers.count).to eq(1)
          expect(q.answers.first.values.count).to eq(2)
          expect(q.answers.first.values.first.value).to eq(good_value.first)
          expect(q.answers.first.values.last.value).to eq(good_value.last)
        end
      end
    end
  end
end