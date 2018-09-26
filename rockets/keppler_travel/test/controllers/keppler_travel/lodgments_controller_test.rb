require 'test_helper'

module KepplerTravel
  class LodgmentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @lodgment = keppler_travel_lodgments(:one)
    end

    test "should get index" do
      get lodgments_url
      assert_response :success
    end

    test "should get new" do
      get new_lodgment_url
      assert_response :success
    end

    test "should create lodgment" do
      assert_difference('Lodgment.count') do
        post lodgments_url, params: { lodgment: { deleted_at: @lodgment.deleted_at, position: @lodgment.position, title: @lodgment.title } }
      end

      assert_redirected_to lodgment_url(Lodgment.last)
    end

    test "should show lodgment" do
      get lodgment_url(@lodgment)
      assert_response :success
    end

    test "should get edit" do
      get edit_lodgment_url(@lodgment)
      assert_response :success
    end

    test "should update lodgment" do
      patch lodgment_url(@lodgment), params: { lodgment: { deleted_at: @lodgment.deleted_at, position: @lodgment.position, title: @lodgment.title } }
      assert_redirected_to lodgment_url(@lodgment)
    end

    test "should destroy lodgment" do
      assert_difference('Lodgment.count', -1) do
        delete lodgment_url(@lodgment)
      end

      assert_redirected_to lodgments_url
    end
  end
end
