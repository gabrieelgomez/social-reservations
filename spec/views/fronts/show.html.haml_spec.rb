require 'rails_helper'

RSpec.describe "fronts/show", type: :view do
  before(:each) do
    @front = assign(:front, Front.create!(
      :index => "Index"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Index/)
  end
end
