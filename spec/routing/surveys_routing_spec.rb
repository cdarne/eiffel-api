require "rails_helper"

RSpec.describe SurveysController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/surveys").to route_to("surveys#index")
    end

    it "routes to #show" do
      expect(:get => "/surveys/1").to route_to("surveys#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/surveys").to route_to("surveys#create")
    end

    it "routes to #destroy" do
      expect(:delete => "/surveys/1").to route_to("surveys#destroy", :id => "1")
    end

    it "routes to #answer" do
      expect(:post => "/surveys/1/answer").to route_to("surveys#answer", :id => "1")
    end
  end
end
