require "application_system_test_case"

module KepplerContactus
  class MessagesTest < ApplicationSystemTestCase
    setup do
      @message = keppler_contactus_messages(:one)
    end

    test "visiting the index" do
      visit messages_url
      assert_selector "h1", text: "Messages"
    end

    test "creating a Message" do
      visit messages_url
      click_on "New Message"

      fill_in "Deleted At", with: @message.deleted_at
      fill_in "Email", with: @message.email
      fill_in "Message", with: @message.message
      fill_in "Name", with: @message.name
      fill_in "Position", with: @message.position
      fill_in "Read", with: @message.read
      fill_in "Subject", with: @message.subject
      click_on "Create Message"

      assert_text "Message was successfully created"
      click_on "Back"
    end

    test "updating a Message" do
      visit messages_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @message.deleted_at
      fill_in "Email", with: @message.email
      fill_in "Message", with: @message.message
      fill_in "Name", with: @message.name
      fill_in "Position", with: @message.position
      fill_in "Read", with: @message.read
      fill_in "Subject", with: @message.subject
      click_on "Update Message"

      assert_text "Message was successfully updated"
      click_on "Back"
    end

    test "destroying a Message" do
      visit messages_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Message was successfully destroyed"
    end
  end
end
