require 'rails_helper'

RSpec.describe PostImage do
	it { is_expected.to belong_to(:post) }

  describe 'バリデーション成功' do
    context 'サブ画像,説明文を入力した場合' do
      it '投稿が作成されること' do
        post_image = build(:post_image)
        expect(post_image).to be_valid
        expect(post_image.errors).to be_empty
      end
    end
	end

  describe 'バリデーション失敗' do
    context 'サブ画像が空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        post_image = build(:post_image, image: '')
        expect(post_image).to be_invalid
        expect(post_image.errors[:image]).to include('を選択してください')
      end
    end

		context '説明文が65_535文字を超える場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        post_image = build(:post_image, caption: 'a' * 65_536)
        expect(post_image).to be_invalid
        expect(post_image.errors[:caption]).to include('は65535文字以内で入力してください')
      end
    end
	end
end