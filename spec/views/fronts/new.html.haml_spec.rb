require 'rails_helper'

RSpec.describe "fronts/new", type: :view do
  before(:each) do
    assign(:front, Front.new(
      :index => "MyString"
    ))
  end

  it "renders new front form" do
    render

    assert_select "form[action=?][method=?]", fronts_path, "post" do

      assert_select "input[name=?]", "front[index]"
    end
  end
end
