class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_update_path_for(_resource)
    profile_path
  end
end
