require "application_system_test_case"

module KepplerTravel
  class AgenciesTest < ApplicationSystemTestCase
    setup do
      @agency = keppler_travel_agencies(:one)
    end

    test "visiting the index" do
      visit agencies_url
      assert_selector "h1", text: "Agencies"
    end

    test "creating a Agency" do
      visit agencies_url
      click_on "New Agency"

      fill_in "Comission Percentage", with: @agency.comission_percentage
      fill_in "Deleted At", with: @agency.deleted_at
      fill_in "Lending Percentage", with: @agency.lending_percentage
      fill_in "Position", with: @agency.position
      fill_in "Unique Code", with: @agency.unique_code
      fill_in "User", with: @agency.user_id
      click_on "Create Agency"

      assert_text "Agency was successfully created"
      click_on "Back"
    end

    test "updating a Agency" do
      visit agencies_url
      click_on "Edit", match: :first

      fill_in "Comission Percentage", with: @agency.comission_percentage
      fill_in "Deleted At", with: @agency.deleted_at
      fill_in "Lending Percentage", with: @agency.lending_percentage
      fill_in "Position", with: @agency.position
      fill_in "Unique Code", with: @agency.unique_code
      fill_in "User", with: @agency.user_id
      click_on "Update Agency"

      assert_text "Agency was successfully updated"
      click_on "Back"
    end

    test "destroying a Agency" do
      visit agencies_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Agency was successfully destroyed"
    end
  end
end
