require 'test_helper'

module KepplerTravel
  class CircuitsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @circuit = keppler_travel_circuits(:one)
    end

    test "should get index" do
      get circuits_url
      assert_response :success
    end

    test "should get new" do
      get new_circuit_url
      assert_response :success
    end

    test "should create circuit" do
      assert_difference('Circuit.count') do
        post circuits_url, params: { circuit: { deleted_at: @circuit.deleted_at, description: @circuit.description, exclude: @circuit.exclude, files: @circuit.files, include: @circuit.include, itinerary: @circuit.itinerary, position: @circuit.position, quantity_days: @circuit.quantity_days, status: @circuit.status, title: @circuit.title } }
      end

      assert_redirected_to circuit_url(Circuit.last)
    end

    test "should show circuit" do
      get circuit_url(@circuit)
      assert_response :success
    end

    test "should get edit" do
      get edit_circuit_url(@circuit)
      assert_response :success
    end

    test "should update circuit" do
      patch circuit_url(@circuit), params: { circuit: { deleted_at: @circuit.deleted_at, description: @circuit.description, exclude: @circuit.exclude, files: @circuit.files, include: @circuit.include, itinerary: @circuit.itinerary, position: @circuit.position, quantity_days: @circuit.quantity_days, status: @circuit.status, title: @circuit.title } }
      assert_redirected_to circuit_url(@circuit)
    end

    test "should destroy circuit" do
      assert_difference('Circuit.count', -1) do
        delete circuit_url(@circuit)
      end

      assert_redirected_to circuits_url
    end
  end
end
