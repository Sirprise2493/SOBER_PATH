class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    # Used by public mini profile inside chat popup
    @friendship = Friendship.between(current_user, @user).first

    unless turbo_frame_request?
      redirect_to profile_path and return
    end
  end

  def profile
    @user = current_user

    @incoming_requests = current_user.friendships_received.pending.includes(:asker)
    @outgoing_requests = current_user.friendships_sent.pending.includes(:receiver)
    @friends           = current_user.friends
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      flash.now[:alert] = "Please correct the errors below."
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :username,
      :date_of_birth, :address,
      :headline, :bio,
      :sobriety_start_date, :counsellor,
      :avatar
    )
  end
end
