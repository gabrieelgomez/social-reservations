require "application_system_test_case"

module KepplerTravel
  class ReservationsTest < ApplicationSystemTestCase
    setup do
      @reservation = keppler_travel_reservations(:one)
    end

    test "visiting the index" do
      visit reservations_url
      assert_selector "h1", text: "Reservations"
    end

    test "creating a Reservation" do
      visit reservations_url
      click_on "New Reservation"

      fill_in "Airport Origin", with: @reservation.airport_origin
      fill_in "Arrival", with: @reservation.arrival
      fill_in "Deleted At", with: @reservation.deleted_at
      fill_in "Flight Arrival", with: @reservation.flight_arrival
      fill_in "Flight Origin", with: @reservation.flight_origin
      fill_in "Origin", with: @reservation.origin
      fill_in "Position", with: @reservation.position
      fill_in "Quantity Adults", with: @reservation.quantity_adults
      fill_in "Quantity Kid", with: @reservation.quantity_kid
      fill_in "Quantity Kids", with: @reservation.quantity_kids
      fill_in "Roud Trip", with: @reservation.roud_trip
      fill_in "User", with: @reservation.user_id
      click_on "Create Reservation"

      assert_text "Reservation was successfully created"
      click_on "Back"
    end

    test "updating a Reservation" do
      visit reservations_url
      click_on "Edit", match: :first

      fill_in "Airport Origin", with: @reservation.airport_origin
      fill_in "Arrival", with: @reservation.arrival
      fill_in "Deleted At", with: @reservation.deleted_at
      fill_in "Flight Arrival", with: @reservation.flight_arrival
      fill_in "Flight Origin", with: @reservation.flight_origin
      fill_in "Origin", with: @reservation.origin
      fill_in "Position", with: @reservation.position
      fill_in "Quantity Adults", with: @reservation.quantity_adults
      fill_in "Quantity Kid", with: @reservation.quantity_kid
      fill_in "Quantity Kids", with: @reservation.quantity_kids
      fill_in "Roud Trip", with: @reservation.roud_trip
      fill_in "User", with: @reservation.user_id
      click_on "Update Reservation"

      assert_text "Reservation was successfully updated"
      click_on "Back"
    end

    test "destroying a Reservation" do
      visit reservations_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Reservation was successfully destroyed"
    end
  end
end
