class AiChatMessagesController < ApplicationController
  def create
    # Needed for re-rendering the chatroom on validation errors
    @ai_chat_messages = current_user.ai_chat_messages.order(:created_at)
    @ai_chat_message  = AiChatMessage.new(ai_chat_message_params)
    @ai_chat_message.user = current_user

    if @ai_chat_message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            :ai_chat_messages,                                # targets <div id="ai_chat_messages">
            partial: "ai_chat_messages/ai_chat_message",      # _ai_chat_message.html.erb
            locals: { ai_chat_message: @ai_chat_message }
          )
        end
        format.html { redirect_to chatroom_path }
      end
    else
      render "pages/chatroom", status: :unprocessable_entity
    end
  end

  private

  def ai_chat_message_params
    params.require(:ai_chat_message).permit(:message_content)
  end
end
