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

		context 'Youtube動画、説明文を入力した場合' do
      it '投稿が作成されること' do
        post = build(:post)
				post_video = build(:post_video)
				post.post_videos << post_video
        expect(post).to be_valid
        expect(post.errors).to be_empty
      end
    end
  end

	describe 'バリデーション失敗' do
    context 'titleが空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
				post =build(:post, title: '')
        expect(post).to be_invalid
        expect(post.errors[:title]).to include('を入力してください')
      end
    end

    context 'titleが255文字を超える場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
				post = build(:post, title: 'a' * 256)
        expect(post).to be_invalid
				expect(post.errors[:title]).to include('は255文字以内で入力してください')
      end
    end

    context 'bodyが空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
				post = build(:post, body: '')
        expect(post).to be_invalid
        expect(post.errors[:body]).to include('を入力してください')
      end
    end

    context 'bodyが65_535文字を超える場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
				post = build(:post, body: 'a' * 65_536)
        expect(post).to be_invalid
				expect(post.errors[:body]).to include('は65535文字以内で入力してください')
      end
    end

    context 'カテゴリが未選択の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
				post = build(:post)
				post.categories.clear
        expect(post).to be_invalid
        expect(post.errors[:categories]).to include('を選択してください')
      end
    end
	end

	describe 'アソシエーション :destroyの挙動' do
    context 'Postを削除した場合' do
      it '関連するコメントも削除される' do
        post = create(:post)
				create(:comment, post: post)
				expect { post.destroy }.to change(Comment, :count).by(-1)
      end

      it '関連するlikesも削除される' do
        post = create(:post)
        create(:like, likeable: post)
        expect { post.destroy }.to change(Like, :count).by(-1)
      end

      it '関連するnotificationsも削除される' do
        post_owner = create(:user)
        liker = create(:user)
        post = create(:post, user: post_owner)
        create(:notification, visitor: liker, visited: post_owner, notifiable: post, action: 'liked')
        expect { post.destroy }.to change(Notification, :count).by(-1)
      end

      # it '関連するpost_imagesも削除される' do
      #   post = create(:post)
      #   create(:post_image, post: post)
      #   expect { post.destroy }.to change(PostImage, :count).by(-1)
      # end

      it '関連するpost_videosも削除される' do
        post = create(:post)
        create(:post_video, post: post)
        expect { post.destroy }.to change(PostVideo, :count).by(-1)
      end

      it '関連するpost_categoriesも削除される' do
        post = create(:post)
        expect { post.destroy }.to change(PostCategory, :count).by(-1)
      end

      it '関連するbookmarksも削除される' do
        post = create(:post)
        create(:bookmark, post: post, user: post.user)
        expect { post.destroy }.to change(Bookmark, :count).by(-1)
      end
    end
	end

end