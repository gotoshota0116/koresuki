class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # ユーザー編集後の遷移先
  def after_update_path_for(_resource)
    profile_path
  end

  # パスワード入力なしで編集
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
