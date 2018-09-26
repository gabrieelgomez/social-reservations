require "application_system_test_case"

module KepplerTravel
  class LodgmentsTest < ApplicationSystemTestCase
    setup do
      @lodgment = keppler_travel_lodgments(:one)
    end

    test "visiting the index" do
      visit lodgments_url
      assert_selector "h1", text: "Lodgments"
    end

    test "creating a Lodgment" do
      visit lodgments_url
      click_on "New Lodgment"

      fill_in "Deleted At", with: @lodgment.deleted_at
      fill_in "Position", with: @lodgment.position
      fill_in "Title", with: @lodgment.title
      click_on "Create Lodgment"

      assert_text "Lodgment was successfully created"
      click_on "Back"
    end

    test "updating a Lodgment" do
      visit lodgments_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @lodgment.deleted_at
      fill_in "Position", with: @lodgment.position
      fill_in "Title", with: @lodgment.title
      click_on "Update Lodgment"

      assert_text "Lodgment was successfully updated"
      click_on "Back"
    end

    test "destroying a Lodgment" do
      visit lodgments_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Lodgment was successfully destroyed"
    end
  end
end
