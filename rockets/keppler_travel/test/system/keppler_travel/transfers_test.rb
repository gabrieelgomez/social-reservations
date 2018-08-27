require "application_system_test_case"

module KepplerTravel
  class TransfersTest < ApplicationSystemTestCase
    setup do
      @transfer = keppler_travel_transfers(:one)
    end

    test "visiting the index" do
      visit transfers_url
      assert_selector "h1", text: "Transfers"
    end

    test "creating a Transfer" do
      visit transfers_url
      click_on "New Transfer"

      fill_in "Cover", with: @transfer.cover
      fill_in "Date", with: @transfer.date
      fill_in "Deleted At", with: @transfer.deleted_at
      fill_in "Position", with: @transfer.position
      fill_in "Price", with: @transfer.price
      fill_in "Quantity Person", with: @transfer.quantity_person
      fill_in "Time", with: @transfer.time
      fill_in "Title", with: @transfer.title
      click_on "Create Transfer"

      assert_text "Transfer was successfully created"
      click_on "Back"
    end

    test "updating a Transfer" do
      visit transfers_url
      click_on "Edit", match: :first

      fill_in "Cover", with: @transfer.cover
      fill_in "Date", with: @transfer.date
      fill_in "Deleted At", with: @transfer.deleted_at
      fill_in "Position", with: @transfer.position
      fill_in "Price", with: @transfer.price
      fill_in "Quantity Person", with: @transfer.quantity_person
      fill_in "Time", with: @transfer.time
      fill_in "Title", with: @transfer.title
      click_on "Update Transfer"

      assert_text "Transfer was successfully updated"
      click_on "Back"
    end

    test "destroying a Transfer" do
      visit transfers_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Transfer was successfully destroyed"
    end
  end
end
