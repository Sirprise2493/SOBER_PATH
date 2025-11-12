class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
  end

  def chatroom
    @ai_chat_messages = current_user.ai_chat_messages.order(created_at: :desc).limit(30).to_a.reverse
    @ai_chat_message = AiChatMessage.new
  end
end
