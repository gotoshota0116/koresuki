require 'rails_helper'

RSpec.describe Comment,focus: true do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:post) }
  it { is_expected.to have_many(:likes).dependent(:destroy) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }

  describe 'バリデーション成功' do
    context '本文が正しく入力されている場合' do
      it 'コメントが作成されること' do
        comment = build(:comment)
        expect(comment).to be_valid
        expect(comment.errors).to be_empty
      end
    end
  end

  describe 'バリデーション失敗' do
    context '本文が空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        comment = build(:comment, body: '')
        expect(comment).to be_invalid
        expect(comment.errors[:body]).to include('を入力してください')
      end
    end

    context '本文が65_535文字を超える場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        comment = build(:comment, body: 'a' * 65_536)
        expect(comment).to be_invalid
        expect(comment.errors[:body]).to include('は65535文字以内で入力してください')
      end
    end
  end

  describe 'アソシエーション :destroyの挙動' do
    context 'コメントを削除した場合' do
	    it '関連するlikesも削除される' do
		    comment = create(:comment)
		  	create(:like, likeable: comment)
		  	expect { comment.destroy }.to change(Like, :count).by(-1)
	    end

      it '関連するnotificationsも削除される' do
        comment_user = create(:user)
        comment = create(:comment, user: comment_user)
				like_user = create(:user)
        create(:notification, visitor: like_user, visited: comment_user, notifiable: comment, action: 'commented')
        expect { comment.destroy }.to change(Notification, :count).by(-1)
      end
		end
	end

end
