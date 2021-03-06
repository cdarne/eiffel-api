require 'rails_helper'

RSpec.describe SurveysController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Survey. As you add validations to Survey, be sure to
  # adjust the attributes here as well.
  let(:valid_survey_attributes) {
    {description: "survey description"}
  }

  let(:valid_attributes) {
    valid_survey_attributes.merge(questions:
                                      [{description: "question description",
                                        question_type: Question::TYPE[:boolean]}])
  }

  let(:invalid_attributes) {
    {description: ""}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SurveysController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all surveys as @surveys" do
      survey = Survey.create! valid_survey_attributes
      get :index, {}, valid_session
      expect(assigns(:surveys)).to eq([survey])
    end
  end

  describe "GET show" do
    it "assigns the requested survey as @survey" do
      survey = Survey.create! valid_survey_attributes
      get :show, {:id => survey.to_param}, valid_session
      expect(assigns(:survey)).to eq(survey)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Survey" do
        expect {
          post :create, {:survey => valid_attributes}, valid_session
        }.to change(Survey, :count).by(1)
      end

      it "assigns a newly created survey as @survey" do
        post :create, {:survey => valid_attributes}, valid_session
        expect(assigns(:survey)).to be_a(Survey)
        expect(assigns(:survey)).to be_persisted
      end

      it "redirects to the created survey" do
        post :create, {:survey => valid_attributes}, valid_session
        assert_response :created
        expect(response.location).to eq(survey_url(Survey.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved survey as @survey" do
        post :create, {:survey => invalid_attributes}, valid_session
        expect(assigns(:survey)).to be_nil
      end

      it "re-renders the 'new' template" do
        post :create, {:survey => invalid_attributes}, valid_session
        assert_response :unprocessable_entity
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested survey" do
      survey = Survey.create! valid_survey_attributes
      expect {
        delete :destroy, {:id => survey.to_param}, valid_session
      }.to change(Survey, :count).by(-1)
    end
  end

  describe "POST answer" do
    describe "with valid params" do
      it "creates an answer" do
        survey = Survey.create! valid_survey_attributes
        survey.questions.create!(order: 0, description: "desc", question_type: Question::TYPE[:boolean])
        expect {
          post :answer, {:id => survey.to_param, answers: {user_id: 42, values: [true]}}, valid_session
        }.to change(Answer, :count).by(1)
      end

      it "responds OK" do
        survey = Survey.create! valid_survey_attributes
        survey.questions.create!(order: 0, description: "desc", question_type: Question::TYPE[:boolean])
        post :answer, {:id => survey.to_param, answers: {user_id: 42, values: [true]}}, valid_session
        assert_response :ok
      end
    end

    describe "with invalid params" do
      it "responds unprocessable_entity" do
        survey = Survey.create! valid_survey_attributes
        survey.questions.create!(order: 0, description: "desc", question_type: Question::TYPE[:boolean])
        post :answer, {:id => survey.to_param, answers: {user_id: 42}}, valid_session
        assert_response :unprocessable_entity
      end
    end
  end
end
