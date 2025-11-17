class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    if @user == current_user
      @incoming_requests = current_user.friendships_received.pending.includes(:asker)
      @outgoing_requests = current_user.friendships_sent.pending.includes(:receiver)
      @friends           = current_user.friends
    else
      @friendship = Friendship.between(current_user, @user).first
    end
  end
end
