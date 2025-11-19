class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  # POST /friendships
  # params: receiver_id
  def create
    receiver = User.find(params[:receiver_id])

    @friendship = current_user.friendships_sent.build(receiver: receiver)

    if @friendship.save
      redirect_back fallback_location: user_path(receiver),
                    notice: "Connect request sent."
    else
      redirect_back fallback_location: user_path(receiver),
                    alert: @friendship.errors.full_messages.to_sentence
    end
  end

  # PATCH /friendships/:id
  # params: status = "accepted" or "declined"
  def update
    # Only the receiver can accept/decline
    @friendship = current_user.friendships_received.find(params[:id])

    case params[:status]
    when "accepted"
      @friendship.accepted!
      message = "Connection accepted."
    when "declined"
      @friendship.declined!
      message = "Connection declined."
    else
      message = "Invalid action."
    end

    redirect_back fallback_location: user_path(@friendship.asker),
                  notice: message
  end

  # Remove an existing friendship/connection (either side can do this)
  def destroy
    @friendship = Friendship
                    .between(current_user, User.find(params[:user_id]))
                    .find(params[:id])

    @friendship.destroy

    redirect_back fallback_location: user_path(params[:user_id]),
                  notice: "Connection removed."
  end
end