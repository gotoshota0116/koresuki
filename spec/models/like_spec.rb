require 'rails_helper'

RSpec.describe Like do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:likeable) }

  describe 'バリデーション成功' do
    context 'ユーザーとlikeableが一意である場合' do
      it '投稿にいいねが作成されること' do
		post = create(:post)
        like = build(:like, likeable: post)
        expect(like).to be_valid
        expect(like.errors).to be_empty
      end
    end

	context 'ユーザーとlikeableが一意である場合' do
		it 'コメントにいいねが作成されること' do
		  comment = create(:comment)
		  like = build(:like, likeable: comment)
		  expect(like).to be_valid
		  expect(like.errors).to be_empty
		end
	  end
  end

  describe 'バリデーション失敗' do
    context '同じユーザーが同じ投稿に対していいねを複数回した場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
		post = create(:post)
        like = create(:like, likeable: post)
        like2 = build(:like, user: like.user, likeable: post)
        expect(like2).to be_invalid
        expect(like2.errors[:user_id]).to include('はすでに存在します')
      end
    end

	context '同じユーザーが同じコメントに対していいねを複数回した場合' do
		it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
		  comment = create(:comment)
		  like = create(:like, likeable: comment)
		  like2 = build(:like, user: like.user, likeable: comment)
		  expect(like2).to be_invalid
		  expect(like2.errors[:user_id]).to include('はすでに存在します')
		end
	  end
  end
end
