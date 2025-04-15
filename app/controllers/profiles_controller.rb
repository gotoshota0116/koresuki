class ProfilesController < ApplicationController
  def show
    @user = current_user
    @posts  = current_user.posts.includes(:post_videos).order(created_at: :desc)
    @bookmark_posts = current_user.bookmark_posts.includes(:user, :post_videos).order(created_at: :desc)
    @current_user_likes = current_user.present? ? current_user.likes.where(likeable_type: 'Post').index_by(&:likeable_id) : {}
    @current_user_bookmarks = current_user.present? ? current_user.bookmarks.index_by(&:post_id) : {}
  end
end
