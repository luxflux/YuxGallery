require "spec_helper"

describe PhotoJobsController do
  describe "routing" do

    it "routes to #index" do
      get("/photo_jobs").should route_to("photo_jobs#index")
    end

    it "routes to #new" do
      get("/photo_jobs/new").should route_to("photo_jobs#new")
    end

    it "routes to #show" do
      get("/photo_jobs/1").should route_to("photo_jobs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/photo_jobs/1/edit").should route_to("photo_jobs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/photo_jobs").should route_to("photo_jobs#create")
    end

    it "routes to #update" do
      put("/photo_jobs/1").should route_to("photo_jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/photo_jobs/1").should route_to("photo_jobs#destroy", :id => "1")
    end

  end
end
