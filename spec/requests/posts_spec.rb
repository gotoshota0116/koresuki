require 'rails_helper'

RSpec.describe "Posts", type: :request, focus: true do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post, user: user) }

  describe 'アクセス制限の確認（skip_before_action :authenticate_user!）' do
    context 'ログイン前' do
      it 'indexページにアクセスできる' do
        get posts_path
        expect(response).to have_http_status(:success)
      end

      it 'showページにアクセスできる' do
        get post_path(post_obj)
        expect(response).to have_http_status(:success)
      end

      it 'newページにアクセスできない' do
        get new_post_path
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq 'ログインもしくはアカウント登録してください。'
      end

      it 'editページにアクセスできない' do
        get edit_post_path(post_obj)
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq 'ログインもしくはアカウント登録してください。'
      end
    end

    context 'ログイン後' do
      before { sign_in user }

      it 'indexページにアクセスできる' do
        get posts_path
        expect(response).to have_http_status(:success)
      end

      it 'showページにアクセスできる' do
        get post_path(post_obj)
        expect(response).to have_http_status(:success)
      end

      it 'newページにアクセスできる' do
        get new_post_path
        expect(response).to have_http_status(:success)
      end

      context '自分の投稿の場合' do
        it 'editページにアクセスできる' do
          get edit_post_path(post_obj)
          expect(response).to have_http_status(:success)
        end
      end

      context '他人の投稿の場合' do
        let(:other_user) { create(:user) }
        let(:other_post) { create(:post, user: other_user) }

        it 'editページにアクセスできない' do
          get edit_post_path(other_post)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
