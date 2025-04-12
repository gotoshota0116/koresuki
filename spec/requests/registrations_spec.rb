require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  # オーバーライドしたregistrationsコントローラーのテスト
  describe 'ユーザー情報の編集' do
    context 'パスワード入力なしでプロフィールを更新した場合' do
      it '更新され、プロフィール画面に遷移する' do
        patch user_registration_path, params: {
          user: {
            name: '新しい名前',
            email: user.email,
            password: ''
          }
        }
        expect(response).to redirect_to profile_path
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include('新しい名前')
      end
    end
  end
end
