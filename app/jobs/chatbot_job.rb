class ChatbotJob < ApplicationJob
  queue_as :default

  # Expects an AiChatMessage record
  def perform(ai_chat_message)
    @message = ai_chat_message

    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: messages_formatted_for_openai
      }
    )

    new_content = chatgpt_response.dig("choices", 0, "message", "content")
    @message.update(ai_answer: new_content)

    # Broadcast a partial update of this single message bubble
    # Stream name and target match your view:
    #   turbo_stream_from dom_id(ai_chat_message)  -> "ai_chat_message_<id>"
    #   element id in DOM                          -> "ai_chat_message_<id>"
    Turbo::StreamsChannel.broadcast_update_to(
      "ai_chat_message_#{@message.id}",
      target:  "ai_chat_message_#{@message.id}",
      partial: "ai_chat_messages/ai_chat_message",
      locals:  { ai_chat_message: @message }
    )
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  # Build the conversation history from the user's prior messages
  def messages_formatted_for_openai
    history = @message.user.ai_chat_messages.order(:created_at)

    results = []
    results << {
      role: "system",
      content: "You are an assistant to help fighting alcohol addiction."
    }

    history.each do |m|
      results << { role: "user",      content: m.message_content }
      results << { role: "assistant", content: m.ai_answer.to_s } # empty answer -> ""
    end

    results
  end
end
