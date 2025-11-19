class UserChatMessagesResponsesController < ApplicationController
  before_action :authenticate_user!

  def create
    @response = UserChatMessagesResponse.new(response_params)
    @response.user = current_user

    if @response.save
      @user_chat_message = @response.user_chat_message
      render "user_chat_messages/show"
    else
      @user_chat_message = @response.user_chat_message
      render "user_chat_messages/show", status: :unprocessable_entity
    end
  end

  def destroy
    @response = UserChatMessagesResponse.find_by!(id: params[:id], user: current_user)
    @user_chat_message = @response.user_chat_message
    @response.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@response)
      end

      format.html do
        redirect_to user_chat_message_path(@user_chat_message),
                    notice: "Comment deleted."
      end
    end
  end

  private

  def response_params
    params.require(:user_chat_messages_response).permit(:message_content, :user_chat_message_id)
  end
end