require 'test_helper'

module KepplerTravel
  class TransfersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @transfer = keppler_travel_transfers(:one)
    end

    test "should get index" do
      get transfers_url
      assert_response :success
    end

    test "should get new" do
      get new_transfer_url
      assert_response :success
    end

    test "should create transfer" do
      assert_difference('Transfer.count') do
        post transfers_url, params: { transfer: { cover: @transfer.cover, date: @transfer.date, deleted_at: @transfer.deleted_at, position: @transfer.position, price: @transfer.price, quantity_person: @transfer.quantity_person, time: @transfer.time, title: @transfer.title } }
      end

      assert_redirected_to transfer_url(Transfer.last)
    end

    test "should show transfer" do
      get transfer_url(@transfer)
      assert_response :success
    end

    test "should get edit" do
      get edit_transfer_url(@transfer)
      assert_response :success
    end

    test "should update transfer" do
      patch transfer_url(@transfer), params: { transfer: { cover: @transfer.cover, date: @transfer.date, deleted_at: @transfer.deleted_at, position: @transfer.position, price: @transfer.price, quantity_person: @transfer.quantity_person, time: @transfer.time, title: @transfer.title } }
      assert_redirected_to transfer_url(@transfer)
    end

    test "should destroy transfer" do
      assert_difference('Transfer.count', -1) do
        delete transfer_url(@transfer)
      end

      assert_redirected_to transfers_url
    end
  end
end
