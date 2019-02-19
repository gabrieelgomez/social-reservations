require 'test_helper'

module KepplerTravel
  class AgentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @agent = keppler_travel_agents(:one)
    end

    test "should get index" do
      get agents_url
      assert_response :success
    end

    test "should get new" do
      get new_agent_url
      assert_response :success
    end

    test "should create agent" do
      assert_difference('Agent.count') do
        post agents_url, params: { agent: { agency_id: @agent.agency_id, comission_percentage: @agent.comission_percentage, deleted_at: @agent.deleted_at, lending_percentage: @agent.lending_percentage, position: @agent.position, unique_code: @agent.unique_code, user_id: @agent.user_id } }
      end

      assert_redirected_to agent_url(Agent.last)
    end

    test "should show agent" do
      get agent_url(@agent)
      assert_response :success
    end

    test "should get edit" do
      get edit_agent_url(@agent)
      assert_response :success
    end

    test "should update agent" do
      patch agent_url(@agent), params: { agent: { agency_id: @agent.agency_id, comission_percentage: @agent.comission_percentage, deleted_at: @agent.deleted_at, lending_percentage: @agent.lending_percentage, position: @agent.position, unique_code: @agent.unique_code, user_id: @agent.user_id } }
      assert_redirected_to agent_url(@agent)
    end

    test "should destroy agent" do
      assert_difference('Agent.count', -1) do
        delete agent_url(@agent)
      end

      assert_redirected_to agents_url
    end
  end
end
