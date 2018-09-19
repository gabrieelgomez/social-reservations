require 'test_helper'

module KepplerTravel
  class ToursControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @tour = keppler_travel_tours(:one)
    end

    test "should get index" do
      get tours_url
      assert_response :success
    end

    test "should get new" do
      get new_tour_url
      assert_response :success
    end

    test "should create tour" do
      assert_difference('Tour.count') do
        post tours_url, params: { tour: { deleted_at: @tour.deleted_at, description: @tour.description, files: @tour.files, name: @tour.name, position: @tour.position, price: @tour.price } }
      end

      assert_redirected_to tour_url(Tour.last)
    end

    test "should show tour" do
      get tour_url(@tour)
      assert_response :success
    end

    test "should get edit" do
      get edit_tour_url(@tour)
      assert_response :success
    end

    test "should update tour" do
      patch tour_url(@tour), params: { tour: { deleted_at: @tour.deleted_at, description: @tour.description, files: @tour.files, name: @tour.name, position: @tour.position, price: @tour.price } }
      assert_redirected_to tour_url(@tour)
    end

    test "should destroy tour" do
      assert_difference('Tour.count', -1) do
        delete tour_url(@tour)
      end

      assert_redirected_to tours_url
    end
  end
end
