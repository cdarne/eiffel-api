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
    @survey = Survey.find(find_params)

    render json: @survey
  end

  # POST /surveys
  # POST /surveys.json
  def create
    builder = SurveyBuilder.new

    if builder.build(survey_params)
      @survey = builder.survey
      render json: @survey, status: :created, location: @survey
    else
      pp builder.errors
      render json: builder.errors, status: :unprocessable_entity
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey = Survey.find(find_params)
    @survey.destroy

    head :no_content
  end

  private

  def find_params
    params.require(:id)
  end

  def survey_params

    params.require(:survey).permit!
  end
end
