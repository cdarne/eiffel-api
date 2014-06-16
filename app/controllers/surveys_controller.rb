class SurveysController < ApplicationController
  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all

    render json: @surveys
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @survey = Survey.find(survey_params[:id])

    render json: @survey
  end

  # POST /surveys
  # POST /surveys.json
  def create
    builder = SurveyBuilder.new

    if builder.build(survey_params[:survey])
      @survey = builder.survey
      render json: @survey, status: :created, location: @survey
    else
      render json: builder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    @survey = Survey.find(survey_params[:id])

    if @survey.update(survey_params[:survey])
      head :no_content
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey = Survey.find(survey_params[:id])
    @survey.destroy

    head :no_content
  end

  private

  def survey_params
    params.permit(:id, survey: {})
  end
end
