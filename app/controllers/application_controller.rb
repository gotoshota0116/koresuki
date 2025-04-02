class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name]) # ユーザー登録
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar]) # 　ユーザー編集
  end
end
