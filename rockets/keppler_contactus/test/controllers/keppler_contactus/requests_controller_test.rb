require 'test_helper'

module KepplerContactus
  class RequestsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @request = keppler_contactus_requests(:one)
    end

    test "should get index" do
      get requests_url
      assert_response :success
    end

    test "should get new" do
      get new_request_url
      assert_response :success
    end

    test "should create request" do
      assert_difference('Request.count') do
        post requests_url, params: { request: { body: @request.body, company: @request.company, country: @request.country, dni: @request.dni, email: @request.email, name: @request.name, options: @request.options, phone: @request.phone } }
      end

      assert_redirected_to request_url(Request.last)
    end

    test "should show request" do
      get request_url(@request)
      assert_response :success
    end

    test "should get edit" do
      get edit_request_url(@request)
      assert_response :success
    end

    test "should update request" do
      patch request_url(@request), params: { request: { body: @request.body, company: @request.company, country: @request.country, dni: @request.dni, email: @request.email, name: @request.name, options: @request.options, phone: @request.phone } }
      assert_redirected_to request_url(@request)
    end

    test "should destroy request" do
      assert_difference('Request.count', -1) do
        delete request_url(@request)
      end

      assert_redirected_to requests_url
    end
  end
end
