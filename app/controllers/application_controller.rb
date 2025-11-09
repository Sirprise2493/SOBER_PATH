class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Allows first_name and last_name in sign_up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    # Allows changing first_name and last_name editing
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
