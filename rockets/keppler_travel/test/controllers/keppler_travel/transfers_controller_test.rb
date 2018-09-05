require 'test_helper'

module KepplerTravel
  class VehiclesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @vehicle = keppler_travel_vehicles(:one)
    end

    test "should get index" do
      get vehicles_url
      assert_response :success
    end

    test "should get new" do
      get new_vehicle_url
      assert_response :success
    end

    test "should create vehicle" do
      assert_difference('Vehicle.count') do
        post vehicles_url, params: { vehicle: { cover: @vehicle.cover, date: @vehicle.date, deleted_at: @vehicle.deleted_at, position: @vehicle.position, price: @vehicle.price, quantity_person: @vehicle.quantity_person, time: @vehicle.time, title: @vehicle.title } }
      end

      assert_redirected_to vehicle_url(Vehicle.last)
    end

    test "should show vehicle" do
      get vehicle_url(@vehicle)
      assert_response :success
    end

    test "should get edit" do
      get edit_vehicle_url(@vehicle)
      assert_response :success
    end

    test "should update vehicle" do
      patch vehicle_url(@vehicle), params: { vehicle: { cover: @vehicle.cover, date: @vehicle.date, deleted_at: @vehicle.deleted_at, position: @vehicle.position, price: @vehicle.price, quantity_person: @vehicle.quantity_person, time: @vehicle.time, title: @vehicle.title } }
      assert_redirected_to vehicle_url(@vehicle)
    end

    test "should destroy vehicle" do
      assert_difference('Vehicle.count', -1) do
        delete vehicle_url(@vehicle)
      end

      assert_redirected_to vehicles_url
    end
  end
end
