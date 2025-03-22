class BookmarksController < ApplicationController

	def create
		@post = Post.find(params[:post_id])
		current_user.bookmark(@post)
		# create.turbo_streamをレンダリング
	end

	def destroy
		@post = current_user.bookmarks.find(params[:id]).post
		current_user.unbookmark(@post)
		# destroy.turbo_streamをレンダリング
	end
end
