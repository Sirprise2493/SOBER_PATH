require "test_helper"

class AiChatMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get ai_chat_messages_create_url
    assert_response :success
  end
end
