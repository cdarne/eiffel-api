class SurveysController < ApplicationController
  # GET /surveys
  # GET /surveys.json
  def index
    scope = Survey.limit(10)

    if stale?(etag: scope.cache_key)
      @surveys = scope.all
      render json: @surveys
    end
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @survey = Survey.find(find_params)

    render json: @survey if stale?(last_modified: @survey.updated_at.utc, etag: @survey.cache_key)
  end

  # POST /surveys
  # POST /surveys.json
  def create
    builder = SurveyBuilder.new

    if builder.build(survey_params)
      @survey = builder.survey
      render json: @survey, status: :created, location: @survey
    else
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
