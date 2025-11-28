class PasswordsController < Devise::PasswordsController
  protected

  # Where to redirect after clicking “Send reset”
  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path
  end
end
