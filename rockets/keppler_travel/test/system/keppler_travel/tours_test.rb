require "application_system_test_case"

module KepplerTravel
  class ToursTest < ApplicationSystemTestCase
    setup do
      @tour = keppler_travel_tours(:one)
    end

    test "visiting the index" do
      visit tours_url
      assert_selector "h1", text: "Tours"
    end

    test "creating a Tour" do
      visit tours_url
      click_on "New Tour"

      fill_in "Deleted At", with: @tour.deleted_at
      fill_in "Description", with: @tour.description
      fill_in "Files", with: @tour.files
      fill_in "Name", with: @tour.name
      fill_in "Position", with: @tour.position
      fill_in "Price", with: @tour.price
      click_on "Create Tour"

      assert_text "Tour was successfully created"
      click_on "Back"
    end

    test "updating a Tour" do
      visit tours_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @tour.deleted_at
      fill_in "Description", with: @tour.description
      fill_in "Files", with: @tour.files
      fill_in "Name", with: @tour.name
      fill_in "Position", with: @tour.position
      fill_in "Price", with: @tour.price
      click_on "Update Tour"

      assert_text "Tour was successfully updated"
      click_on "Back"
    end

    test "destroying a Tour" do
      visit tours_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Tour was successfully destroyed"
    end
  end
end
