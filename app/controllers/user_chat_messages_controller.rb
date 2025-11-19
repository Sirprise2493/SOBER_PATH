class UserChatMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user_chat_message = UserChatMessage.new(user_chat_message_params)
    @user_chat_message.user = current_user

    if @user_chat_message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            :user_chat_messages,
            partial: "user_chat_messages/user_chat_message",
            locals:  { user_chat_message: @user_chat_message }
          )
        end

        format.html { redirect_to chatroom_path, notice: "Message posted." }
      end
    else
      @ai_chat_messages = current_user.ai_chat_messages.order(created_at: :desc).limit(30).to_a.reverse
      @ai_chat_message  = AiChatMessage.new

      @user_chat_messages = UserChatMessage.includes(:user).order(:created_at).limit(50)
      @user_chat_partners = User.joins(:user_chat_messages).where.not(id: current_user.id).distinct
      @all_chat_users     = User.where.not(id: current_user.id).order(:username)

      render "pages/chatroom", status: :unprocessable_entity
    end
  end

  def show
    @user_chat_message = UserChatMessage.includes(:user).find(params[:id])
  end

  def destroy
    @user_chat_message = current_user.user_chat_messages.find(params[:id])

    @user_chat_message.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@user_chat_message)
      end

      format.html do
        redirect_to chatroom_path, notice: "Message deleted."
      end
    end
  end

  private

  def user_chat_message_params
    params.require(:user_chat_message).permit(:message_content)
  end
end
