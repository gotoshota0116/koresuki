class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Omniauth save error: #{e.message}")
    flash[:alert] = "認証中にエラーが発生しました: #{e.record.errors.full_messages.to_sentence}"
    redirect_to new_user_registration_url
  end

  # OmniAuthが認証失敗した時に、裏で自動で呼び出す
  # ユーザーがgoogle認証をキャンセルした、apiキーが無効だったなど
  def failure
    redirect_to root_path, alert: 'Authentication failed, please try again.'
  end
end
