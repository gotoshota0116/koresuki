require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post, user: user) }
  let(:category) { create(:category) }

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

      it '自分の投稿の場合、editページにアクセスできる' do
        get edit_post_path(post_obj)
        expect(response).to have_http_status(:success)
      end

      it '他人の投稿の場合,editページにアクセスできない' do
        other_post = create(:post)
        get edit_post_path(other_post)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'CRUD機能の確認' do
    before { sign_in user }

    context '投稿閲覧 (read)' do
      it '投稿一覧ページが表示される' do
        post_obj
        get posts_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(post_obj.title)
      end

      it '投稿詳細ページが表示される' do
        post_obj
        get post_path(post_obj)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(post_obj.body)
      end
    end

    context '投稿作成(create)' do
      it '正常なパラメータの場合、投稿が作成される' do
        expect do
          post posts_path, params: { post: { title: 'テストタイトル', body: 'テスト本文', category_ids: [category.id] } }
        end.to change(Post, :count).by(1)
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(flash[:notice]).to eq '投稿を作成しました'
      end

      it '不正なパラメータの場合、投稿が作成されない' do
        expect do
          post posts_path, params: { post: { title: '', body: '', category_ids: '' } }
        end.not_to change(Post, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '投稿更新 (update)' do
      it '正常なパラメータの場合、投稿が更新される' do
        patch post_path(post_obj), params: { post: { title: '更新タイトル', body: '更新本文', category_ids: [category.id] } }
        expect(response).to redirect_to post_path(post_obj)
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(flash[:notice]).to eq '投稿を更新しました'
      end

      it '不正なパラメータの場合、投稿が更新されない' do
        patch post_path(post_obj), params: { post: { title: '', body: '', category_ids: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '投稿削除 (delete)' do
      it '投稿が削除される' do
        post_obj
        expect do
          delete post_path(post_obj)
        end.to change(Post, :count).by(-1)
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(flash[:notice]).to eq '投稿を削除しました'
      end
    end
  end
end
