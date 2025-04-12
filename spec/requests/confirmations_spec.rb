require 'rails_helper'

RSpec.describe "Confirmations", type: :request do

  #  オーバーライドしたconfirmationsコントローラーのafter_confirmation_path_forメソッドテスト
  describe 'ユーザーメール認証' do
    let(:user) { create(:user, confirmed_at: nil) }

    it 'メール認証後に自動ログインして root_path にリダイレクトされる' do
      get user_confirmation_path, params: {
			confirmation_token: user.confirmation_token
		  }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(controller.current_user).to eq(user)
      expect(response).to have_http_status(:success)
    end
  end
end
