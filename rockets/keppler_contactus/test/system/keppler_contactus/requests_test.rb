require "application_system_test_case"

module KepplerContactus
  class RequestsTest < ApplicationSystemTestCase
    setup do
      @request = keppler_contactus_requests(:one)
    end

    test "visiting the index" do
      visit requests_url
      assert_selector "h1", text: "Requests"
    end

    test "creating a Request" do
      visit requests_url
      click_on "New Request"

      fill_in "Body", with: @request.body
      fill_in "Company", with: @request.company
      fill_in "Country", with: @request.country
      fill_in "Dni", with: @request.dni
      fill_in "Email", with: @request.email
      fill_in "Name", with: @request.name
      fill_in "Options", with: @request.options
      fill_in "Phone", with: @request.phone
      click_on "Create Request"

      assert_text "Request was successfully created"
      click_on "Back"
    end

    test "updating a Request" do
      visit requests_url
      click_on "Edit", match: :first

      fill_in "Body", with: @request.body
      fill_in "Company", with: @request.company
      fill_in "Country", with: @request.country
      fill_in "Dni", with: @request.dni
      fill_in "Email", with: @request.email
      fill_in "Name", with: @request.name
      fill_in "Options", with: @request.options
      fill_in "Phone", with: @request.phone
      click_on "Update Request"

      assert_text "Request was successfully updated"
      click_on "Back"
    end

    test "destroying a Request" do
      visit requests_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Request was successfully destroyed"
    end
  end
end
