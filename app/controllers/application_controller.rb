class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    extra = %i[
      first_name last_name username date_of_birth address
      headline bio sobriety_start_date counsellor avatar
    ]

    # --- SIGN UP ---
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, *extra)
    end

    # --- ACCOUNT UPDATE ---
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation, :current_password, *extra)
    end
  end
end
