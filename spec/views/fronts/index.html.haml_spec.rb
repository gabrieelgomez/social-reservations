require 'rails_helper'

RSpec.describe "fronts/index", type: :view do
  before(:each) do
    assign(:fronts, [
      Front.create!(
        :index => "Index"
      ),
      Front.create!(
        :index => "Index"
      )
    ])
  end

  it "renders a list of fronts" do
    render
    assert_select "tr>td", :text => "Index".to_s, :count => 2
  end
end
