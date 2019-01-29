require "application_system_test_case"

module KepplerTravel
  class AgentsTest < ApplicationSystemTestCase
    setup do
      @agent = keppler_travel_agents(:one)
    end

    test "visiting the index" do
      visit agents_url
      assert_selector "h1", text: "Agents"
    end

    test "creating a Agent" do
      visit agents_url
      click_on "New Agent"

      fill_in "Agency", with: @agent.agency_id
      fill_in "Comission Percentage", with: @agent.comission_percentage
      fill_in "Deleted At", with: @agent.deleted_at
      fill_in "Lending Percentage", with: @agent.lending_percentage
      fill_in "Position", with: @agent.position
      fill_in "Unique Code", with: @agent.unique_code
      fill_in "User", with: @agent.user_id
      click_on "Create Agent"

      assert_text "Agent was successfully created"
      click_on "Back"
    end

    test "updating a Agent" do
      visit agents_url
      click_on "Edit", match: :first

      fill_in "Agency", with: @agent.agency_id
      fill_in "Comission Percentage", with: @agent.comission_percentage
      fill_in "Deleted At", with: @agent.deleted_at
      fill_in "Lending Percentage", with: @agent.lending_percentage
      fill_in "Position", with: @agent.position
      fill_in "Unique Code", with: @agent.unique_code
      fill_in "User", with: @agent.user_id
      click_on "Update Agent"

      assert_text "Agent was successfully updated"
      click_on "Back"
    end

    test "destroying a Agent" do
      visit agents_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Agent was successfully destroyed"
    end
  end
end
