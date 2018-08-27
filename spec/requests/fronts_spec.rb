require 'rails_helper'

RSpec.describe "Fronts", type: :request do
  describe "GET /fronts" do
    it "works! (now write some real specs)" do
      get fronts_path
      expect(response).to have_http_status(200)
    end
  end
end
