require 'rails_helper'

RSpec.describe Bookmark do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:post) }

  describe 'バリデーション成功' do
    context 'ユーザーとポストが一意である場合' do
      it 'ブックマークが作成されること' do
        bookmark = build(:bookmark)
        expect(bookmark).to be_valid
        expect(bookmark.errors).to be_empty
      end
    end
  end

  describe 'バリデーション失敗' do
    context '同じユーザーが同じポストに対してブックマークを複数回した場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        bookmark = create(:bookmark)
        bookmark2 = build(:bookmark, user: bookmark.user, post: bookmark.post)
        expect(bookmark2).to be_invalid
        expect(bookmark2.errors[:user_id]).to include('はすでに存在します')
      end
    end
  end
end
