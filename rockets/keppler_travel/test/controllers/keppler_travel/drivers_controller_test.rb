require 'test_helper'

module KepplerTravel
  class DriversControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @driver = keppler_travel_drivers(:one)
    end

    test "should get index" do
      get drivers_url
      assert_response :success
    end

    test "should get new" do
      get new_driver_url
      assert_response :success
    end

    test "should create driver" do
      assert_difference('Driver.count') do
        post drivers_url, params: { driver: { deleted_at: @driver.deleted_at, position: @driver.position, timetrack: @driver.timetrack } }
      end

      assert_redirected_to driver_url(Driver.last)
    end

    test "should show driver" do
      get driver_url(@driver)
      assert_response :success
    end

    test "should get edit" do
      get edit_driver_url(@driver)
      assert_response :success
    end

    test "should update driver" do
      patch driver_url(@driver), params: { driver: { deleted_at: @driver.deleted_at, position: @driver.position, timetrack: @driver.timetrack } }
      assert_redirected_to driver_url(@driver)
    end

    test "should destroy driver" do
      assert_difference('Driver.count', -1) do
        delete driver_url(@driver)
      end

      assert_redirected_to drivers_url
    end
  end
end
