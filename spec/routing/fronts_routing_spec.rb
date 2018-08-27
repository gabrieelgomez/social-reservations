require "rails_helper"

RSpec.describe FrontsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fronts").to route_to("fronts#index")
    end

    it "routes to #new" do
      expect(:get => "/fronts/new").to route_to("fronts#new")
    end

    it "routes to #show" do
      expect(:get => "/fronts/1").to route_to("fronts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/fronts/1/edit").to route_to("fronts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/fronts").to route_to("fronts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fronts/1").to route_to("fronts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fronts/1").to route_to("fronts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/fronts/1").to route_to("fronts#destroy", :id => "1")
    end

  end
end
