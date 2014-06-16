require 'rails_helper'

RSpec.describe AnswerValueEntry, :type => :model do
  describe "Validation" do
    it { should validate_presence_of(:answer_id) }
  end

  describe "value serialization" do
    let(:survey) { Survey.create!(description: "desc") }
    let(:question) { survey.questions.create!(order: 0, description: "desc", question_type: Question::TYPE[:boolean]) }
    let(:answer) { question.answers.create!(user_id: 42) }

    it "should serialize and deserialize the value from the DB" do
      e = AnswerValueEntry.create!(answer_id: answer.id, value: true)
      expect(e.reload.value.class).to eq(TrueClass)

      e = AnswerValueEntry.create!(answer_id: answer.id, value: 42)
      expect(e.reload.value.class).to eq(Fixnum)

      e = AnswerValueEntry.create!(answer_id: answer.id, value: "lol")
      expect(e.reload.value.class).to eq(String)
    end
  end
end
