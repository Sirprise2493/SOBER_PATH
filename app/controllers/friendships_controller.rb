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

  def update
    # Only the receiver can accept/decline
    @friendship = current_user.friendships_received.find(params[:id])

    case params[:status]
    when "accepted"
      @friendship.accepted!
      @notice = "Connection accepted."
    when "declined"
      @friendship.declined!
      @notice = "Connection declined."
    else
      @notice = "Invalid action."
    end

    # fresh data
    @friends            = current_user.friends
    @incoming_requests  = current_user.friendships_received.merge(Friendship.pending)
    @outgoing_requests  = current_user.friendships_sent.merge(Friendship.pending)
    @connection_updates = ConnectionUpdates.for(current_user)

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_back fallback_location: user_path(@friendship.asker),
                      notice: @notice
      end
    end
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
