require 'test_helper'

module KepplerTravel
  class ReservationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @reservation = keppler_travel_reservations(:one)
    end

    test "should get index" do
      get reservations_url
      assert_response :success
    end

    test "should get new" do
      get new_reservation_url
      assert_response :success
    end

    test "should create reservation" do
      assert_difference('Reservation.count') do
        post reservations_url, params: { reservation: { airport_origin: @reservation.airport_origin, arrival: @reservation.arrival, deleted_at: @reservation.deleted_at, flight_arrival: @reservation.flight_arrival, flight_origin: @reservation.flight_origin, origin: @reservation.origin, position: @reservation.position, quantity_adults: @reservation.quantity_adults, quantity_kid: @reservation.quantity_kid, quantity_kids: @reservation.quantity_kids, round_trip: @reservation.round_trip, user_id: @reservation.user_id } }
      end

      assert_redirected_to reservation_url(Reservation.last)
    end

    test "should show reservation" do
      get reservation_url(@reservation)
      assert_response :success
    end

    test "should get edit" do
      get edit_reservation_url(@reservation)
      assert_response :success
    end

    test "should update reservation" do
      patch reservation_url(@reservation), params: { reservation: { airport_origin: @reservation.airport_origin, arrival: @reservation.arrival, deleted_at: @reservation.deleted_at, flight_arrival: @reservation.flight_arrival, flight_origin: @reservation.flight_origin, origin: @reservation.origin, position: @reservation.position, quantity_adults: @reservation.quantity_adults, quantity_kid: @reservation.quantity_kid, quantity_kids: @reservation.quantity_kids, round_trip: @reservation.round_trip, user_id: @reservation.user_id } }
      assert_redirected_to reservation_url(@reservation)
    end

    test "should destroy reservation" do
      assert_difference('Reservation.count', -1) do
        delete reservation_url(@reservation)
      end

      assert_redirected_to reservations_url
    end
  end
end
