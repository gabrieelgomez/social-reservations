require "application_system_test_case"

module KepplerTravel
  class CircuitsTest < ApplicationSystemTestCase
    setup do
      @circuit = keppler_travel_circuits(:one)
    end

    test "visiting the index" do
      visit circuits_url
      assert_selector "h1", text: "Circuits"
    end

    test "creating a Circuit" do
      visit circuits_url
      click_on "New Circuit"

      fill_in "Deleted At", with: @circuit.deleted_at
      fill_in "Description", with: @circuit.description
      fill_in "Exclude", with: @circuit.exclude
      fill_in "Files", with: @circuit.files
      fill_in "Include", with: @circuit.include
      fill_in "Itinerary", with: @circuit.itinerary
      fill_in "Position", with: @circuit.position
      fill_in "Quantity Days", with: @circuit.quantity_days
      fill_in "Status", with: @circuit.status
      fill_in "Title", with: @circuit.title
      click_on "Create Circuit"

      assert_text "Circuit was successfully created"
      click_on "Back"
    end

    test "updating a Circuit" do
      visit circuits_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @circuit.deleted_at
      fill_in "Description", with: @circuit.description
      fill_in "Exclude", with: @circuit.exclude
      fill_in "Files", with: @circuit.files
      fill_in "Include", with: @circuit.include
      fill_in "Itinerary", with: @circuit.itinerary
      fill_in "Position", with: @circuit.position
      fill_in "Quantity Days", with: @circuit.quantity_days
      fill_in "Status", with: @circuit.status
      fill_in "Title", with: @circuit.title
      click_on "Update Circuit"

      assert_text "Circuit was successfully updated"
      click_on "Back"
    end

    test "destroying a Circuit" do
      visit circuits_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Circuit was successfully destroyed"
    end
  end
end
