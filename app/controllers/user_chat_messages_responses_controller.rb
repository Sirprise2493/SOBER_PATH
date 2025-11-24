class UserChatMessagesResponsesController < ApplicationController
  before_action :authenticate_user!

  def create
    @response = UserChatMessagesResponse.new(response_params)
    @response.user = current_user
    @user_chat_message = @response.user_chat_message

    if @response.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            # 1) Update the thread panel content
            turbo_stream.update(
              "message_thread",
              partial: "user_chat_messages/thread",
              locals: { user_chat_message: @user_chat_message }
            ),
            # 2) Update the comment count pill in the main feed
            turbo_stream.update(
              helpers.dom_id(@user_chat_message, :comment_count),
              partial: "user_chat_messages/comment_count",
              locals: { user_chat_message: @user_chat_message }
            )
          ]
        end

        format.html do
          redirect_to chatroom_path(tab: "community")
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream.update(
            "message_thread",
            partial: "user_chat_messages/thread",
            locals: { user_chat_message: @user_chat_message }
          ), status: :unprocessable_entity
        end

        format.html do
          @user_chat_message = @response.user_chat_message
          render "user_chat_messages/show", status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @response = UserChatMessagesResponse.find_by!(id: params[:id], user: current_user)
    @user_chat_message = @response.user_chat_message
    @response.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "message_thread",
            partial: "user_chat_messages/thread",
            locals: { user_chat_message: @user_chat_message }
          ),
          turbo_stream.update(
            helpers.dom_id(@user_chat_message, :comment_count),
            partial: "user_chat_messages/comment_count",
            locals: { user_chat_message: @user_chat_message }
          )
        ]
      end

      format.html do
        redirect_to chatroom_path(tab: "community")
      end
    end
  end

  private

  def response_params
    params
      .require(:user_chat_messages_response)
      .permit(:message_content, :user_chat_message_id)
  end
end