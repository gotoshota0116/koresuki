require 'rails_helper'

RSpec.describe Post do
	it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:likes).dependent(:destroy) }
  it { is_expected.to have_many(:liked_users).through(:likes).source(:user) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }
  it { is_expected.to have_many(:post_images).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:post_images).allow_destroy(true) }
  it { is_expected.to have_many(:post_videos).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:post_videos).allow_destroy(true) }
  it { is_expected.to have_many(:post_categories).dependent(:destroy) }
  it { is_expected.to have_many(:categories).through(:post_categories) }
  it { is_expected.to have_many(:bookmarks).dependent(:destroy) }

	describe 'バリデーション成功' do
    context 'title,body,categoryを正しく入力した場合' do
      it '投稿が作成されること' do
        post = build(:post)
        expect(post).to be_valid
        expect(post.errors).to be_empty
      end
    end

		# context 'サブ画像を入力した場合', focus: true  do
    #   it '投稿が作成されること' do
    #     post = build(:post)
		# 		post_image = build(:post_image, post: post)
		# 		post.post_images << post_image
    #     expect(post).to be_valid
    #     expect(post.errors).to be_empty
    #   end
    # end

		context 'Youtube動画、説明文を入力した場合', focus: true  do
      it '投稿が作成されること' do
        post = build(:post)
				post_video = build(:post_video)
				post.post_videos << post_video
        expect(post).to be_valid
        expect(post.errors).to be_empty
      end
    end
  end
end