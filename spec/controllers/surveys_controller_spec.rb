require 'rails_helper'

RSpec.describe SurveysController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Survey. As you add validations to Survey, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {description: "A description"}
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
      survey = Survey.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:surveys)).to eq([survey])
    end
  end

  describe "GET show" do
    it "assigns the requested survey as @survey" do
      survey = Survey.create! valid_attributes
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
        expect(assigns(:survey)).to be_a_new(Survey)
      end

      it "re-renders the 'new' template" do
        post :create, {:survey => invalid_attributes}, valid_session
        assert_response :unprocessable_entity
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {description: "A new description"}
      }

      it "updates the requested survey" do
        survey = Survey.create! valid_attributes
        put :update, {:id => survey.to_param, :survey => new_attributes}, valid_session
        survey.reload
        expect(survey.description).to eq("A new description")
      end

      it "assigns the requested survey as @survey" do
        survey = Survey.create! valid_attributes
        put :update, {:id => survey.to_param, :survey => valid_attributes}, valid_session
        expect(assigns(:survey)).to eq(survey)
      end
    end

    describe "with invalid params" do
      it "assigns the survey as @survey" do
        survey = Survey.create! valid_attributes
        put :update, {:id => survey.to_param, :survey => invalid_attributes}, valid_session
        expect(assigns(:survey)).to eq(survey)
      end

      it "re-renders the 'edit' template" do
        survey = Survey.create! valid_attributes
        expect_any_instance_of(Survey).to receive(:update).and_return(false)
        put :update, {:id => survey.to_param, :survey => invalid_attributes}, valid_session
        assert_response :unprocessable_entity
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested survey" do
      survey = Survey.create! valid_attributes
      expect {
        delete :destroy, {:id => survey.to_param}, valid_session
      }.to change(Survey, :count).by(-1)
    end
  end
end
