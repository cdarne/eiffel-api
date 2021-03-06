class SurveysController < ApplicationController
  # GET /surveys
  # GET /surveys.json
  def index
    scope = Survey.limit(10)

    # Sets the etag on the response and checks it against the client request
    if stale?(etag: scope.cache_key, public: true)
      @surveys = scope.all
      render json: @surveys
    end
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @survey = Survey.find(find_params)

    # Sets the etag and last_modified on the response and checks it against the client request
    if stale?(last_modified: @survey.updated_at.utc, etag: @survey.cache_key, public: true)
      render json: @survey
    end
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

  # POST /surveys/1/answer
  # POST /surveys/1/answer.json
  def answer
    survey = Survey.find(find_params)
    sa = SurveyAnswerer.new(survey)

    if sa.answer(answer_params)
      head :ok
    else
      render json: sa.errors, status: :unprocessable_entity
    end
  end

  private

  def find_params
    params.require(:id)
  end

  def survey_params
    params.require(:survey).permit!
  end

  def answer_params
    params.require(:answers).permit!
  end
end
