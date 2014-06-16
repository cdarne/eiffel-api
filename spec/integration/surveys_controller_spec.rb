require 'rails_helper'
require 'multi_json'

RSpec.describe SurveysController, :type => :request do
  it "creating and listing" do
    headers = {'CONTENT_TYPE' => 'application/json'}
    src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'NosQuestionsVosReponses.json'))
    post "/surveys.json", src_json, headers

    expect(response.code).to eq("201")

    src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'ParisMonAmi.json'))
    post "/surveys.json", src_json, headers

    expect(response.code).to eq("201")

    src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'SondageMieux.json'))
    post "/surveys.json", src_json, headers

    expect(response.code).to eq("201")

    expect(Survey.count).to eq(3)
    expect(Question.count).to eq(6 + 4 + 2)
    expect(SelectValue.count).to eq(4)
    expect(RatingValue.count).to eq(1)
    expect(RatioValue.count).to eq(2)

    get "/surveys.json"
    expect(response.code).to eq("200")
    rsp_json = MultiJson.decode(response.body)
    expect(rsp_json["surveys"].size).to eq(3)
    expect(rsp_json["surveys"][0]["questions"].size).to eq(6)
    expect(rsp_json["surveys"][1]["questions"].size).to eq(4)
    expect(rsp_json["surveys"][2]["questions"].size).to eq(2)
  end

  describe "answering" do
    it "NosQuestionsVosReponses" do
      headers = {'CONTENT_TYPE' => 'application/json'}
      src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'NosQuestionsVosReponses.json'))
      post "/surveys.json", src_json, headers
      rsp_json = MultiJson.decode(response.body)
      survey_id = rsp_json["survey"]["id"]

      src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'NosQuestionsVosReponses_response.json'))
      post "/surveys/#{survey_id}/answer.json", src_json, headers

      expect(response.code).to eq("200")

      expect(Answer.count).to eq(6)
    end

    it "ParisMonAmi" do
      headers = {'CONTENT_TYPE' => 'application/json'}
      src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'ParisMonAmi.json'))
      post "/surveys.json", src_json, headers
      rsp_json = MultiJson.decode(response.body)
      survey_id = rsp_json["survey"]["id"]

      src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'ParisMonAmi_response.json'))
      post "/surveys/#{survey_id}/answer.json", src_json, headers

      expect(response.code).to eq("200")

      expect(Answer.count).to eq(4)
    end

    it "ParisMonAmi" do
      headers = {'CONTENT_TYPE' => 'application/json'}
      src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'SondageMieux.json'))
      post "/surveys.json", src_json, headers
      rsp_json = MultiJson.decode(response.body)
      survey_id = rsp_json["survey"]["id"]

      src_json = File.read(File.join(Rails.root, 'spec', 'fixtures', 'SondageMieux_response.json'))
      post "/surveys/#{survey_id}/answer.json", src_json, headers

      expect(response.code).to eq("200")

      expect(Answer.count).to eq(2)
    end
  end
end
