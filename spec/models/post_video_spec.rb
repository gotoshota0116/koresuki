require 'rails_helper'

RSpec.describe PostVideo do
  it { is_expected.to belong_to(:post) }

  describe 'バリデーション成功' do
    context 'YoutubeURL,説明文を入力した場合' do
      it '投稿が作成されること' do
        post_video = build(:post_video)
        expect(post_video).to be_valid
        expect(post_video.errors).to be_empty
      end
    end
  end

  describe 'バリデーション失敗' do
    context 'YoutubeURLが空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        post_video = build(:post_video, youtube_url: '')
        expect(post_video).to be_invalid
        expect(post_video.errors[:youtube_url]).to include('を入力してください')
      end
    end

    context 'YoutubeURLが255文字を超える場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        post_video = build(:post_video, youtube_url: 'a' * 256)
        expect(post_video).to be_invalid
        expect(post_video.errors[:youtube_url]).to include('は255文字以内で入力してください')
      end
    end

    context '説明文が65_535文字を超える場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        post_video = build(:post_video, caption: 'a' * 65_536)
        expect(post_video).to be_invalid
        expect(post_video.errors[:caption]).to include('は65535文字以内で入力してください')
      end
    end
  end
end
