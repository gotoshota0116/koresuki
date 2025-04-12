require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'ログイン成功' do
    let(:user) { create(:user) }

    context 'email、passwordを正しく入力した場合' do
      it 'ログインに成功する' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }
        expect(response).to redirect_to root_path
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ログインしました')
      end
    end
  end

  describe 'ログイン失敗' do
    let(:user) { create(:user) }

    context 'emailが間違っている場合' do
      it 'ログインに失敗する' do
        post user_session_path, params: {
          user: {
            email: 'wrong_email',
            password: user.password
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Eメールまたはパスワードが違います')
      end
    end

    context 'パスワードが間違っている場合' do
      it 'ログインに失敗する' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrong_password'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Eメールまたはパスワードが違います')
      end
    end
  end
end
