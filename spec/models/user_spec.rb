require 'rails_helper'

RSpec.describe User do
  it { is_expected.to have_many(:posts).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:likes).dependent(:destroy) }

  it {
    expect(subject).to have_many(:active_notifications)
      .class_name('Notification')
      .with_foreign_key('visitor_id')
      .inverse_of(:visitor)
      .dependent(:destroy)
  }

  it {
    expect(subject).to have_many(:passive_notifications)
      .class_name('Notification')
      .with_foreign_key('visited_id')
      .inverse_of(:visited)
      .dependent(:destroy)
  }

  it { is_expected.to have_many(:bookmarks).dependent(:destroy) }

  describe 'バリデーション成功' do
    context 'name,email,password,password_confirmationを正しく入力した場合' do
      it 'ユーザーが作成されること' do
        user = build(:user)
        expect(user).to be_valid
        expect(user.errors).to be_empty
      end
    end
  end

  describe 'バリデーション失敗' do
    context 'nameが空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        user = build(:user, name: 'a' * 256)
        expect(user).to be_invalid
        expect(user.errors[:name]).to include('は255文字以内で入力してください')
      end
    end

    context 'nameが255文字を超える場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        user = build(:user, name: '')
        expect(user).to be_invalid
        expect(user.errors[:name]).to include('を入力してください')
      end
    end

    context 'emailが空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        user = build(:user, email: '')
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('を入力してください')
      end
    end

    context 'passwordが空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        user = build(:user, password: '')
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('を入力してください')
      end
    end

    context 'password_confirmationが空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        user = build(:user, password_confirmation: '')
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
      end
    end

    context 'providerとuidが重複した場合' do
      it 'バリデーションが発生し、エラーメッセージが表示されること' do
        create(:user, provider: 'google_auth2', uid: '12345')
        user2 = build(:user, provider: 'google_auth2', uid: '12345')
        expect(user2).to be_invalid
        expect(user2.errors[:uid]).to include('はすでに存在します')
      end
    end
  end

  describe 'アソシエーション :destroyの挙動' do
    context 'Userを削除すると' do
      it '関連するPostも削除される' do
        user = create(:user)
        create(:post, user: user)
        expect { user.destroy }.to change { Post.count }.by(-1)
      end
    end

    context 'Userを削除すると' do
      it '関連するCommentも削除される' do
        user = create(:user)
        post = create(:post, user: user)
        create(:comment, post: post)
        expect { user.destroy }.to change { Comment.count }.by(-1)
      end
    end
  end
end
