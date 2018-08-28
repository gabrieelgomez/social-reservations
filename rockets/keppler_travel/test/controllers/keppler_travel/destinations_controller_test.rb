require 'test_helper'

module KepplerTravel
  class DestinationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @destination = keppler_travel_destinations(:one)
    end

    test "should get index" do
      get destinations_url
      assert_response :success
    end

    test "should get new" do
      get new_destination_url
      assert_response :success
    end

    test "should create destination" do
      assert_difference('Destination.count') do
        post destinations_url, params: { destination: { cover: @destination.cover, deleted_at: @destination.deleted_at, description: @destination.description, position: @destination.position, title: @destination.title } }
      end

      assert_redirected_to destination_url(Destination.last)
    end

    test "should show destination" do
      get destination_url(@destination)
      assert_response :success
    end

    test "should get edit" do
      get edit_destination_url(@destination)
      assert_response :success
    end

    test "should update destination" do
      patch destination_url(@destination), params: { destination: { cover: @destination.cover, deleted_at: @destination.deleted_at, description: @destination.description, position: @destination.position, title: @destination.title } }
      assert_redirected_to destination_url(@destination)
    end

    test "should destroy destination" do
      assert_difference('Destination.count', -1) do
        delete destination_url(@destination)
      end

      assert_redirected_to destinations_url
    end
  end
end
