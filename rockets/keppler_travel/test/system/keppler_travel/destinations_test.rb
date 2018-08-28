require "application_system_test_case"

module KepplerTravel
  class DestinationsTest < ApplicationSystemTestCase
    setup do
      @destination = keppler_travel_destinations(:one)
    end

    test "visiting the index" do
      visit destinations_url
      assert_selector "h1", text: "Destinations"
    end

    test "creating a Destination" do
      visit destinations_url
      click_on "New Destination"

      fill_in "Cover", with: @destination.cover
      fill_in "Deleted At", with: @destination.deleted_at
      fill_in "Description", with: @destination.description
      fill_in "Position", with: @destination.position
      fill_in "Title", with: @destination.title
      click_on "Create Destination"

      assert_text "Destination was successfully created"
      click_on "Back"
    end

    test "updating a Destination" do
      visit destinations_url
      click_on "Edit", match: :first

      fill_in "Cover", with: @destination.cover
      fill_in "Deleted At", with: @destination.deleted_at
      fill_in "Description", with: @destination.description
      fill_in "Position", with: @destination.position
      fill_in "Title", with: @destination.title
      click_on "Update Destination"

      assert_text "Destination was successfully updated"
      click_on "Back"
    end

    test "destroying a Destination" do
      visit destinations_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Destination was successfully destroyed"
    end
  end
end
