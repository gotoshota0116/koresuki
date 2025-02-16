class LikesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_post
  
	def create
	  @like = current_user.likes.build(post: @post)
	  if @like.save
		respond_to do |format|
		  format.turbo_stream
		  format.html { redirect_to @post, notice: 'いいねしました！' }
		end
	  else
		render turbo_stream: turbo_stream.replace("like_button_#{@post.id}", partial: "likes/button", locals: { post: @post })
	  end
	end
  
	def destroy
	  @like = current_user.likes.find_by(post: @post)
	  @like&.destroy
	  respond_to do |format|
		format.turbo_stream
		format.html { redirect_to @post, notice: 'いいねを取り消しました' }
	  end
	end
  
	private
  
	def set_post
	  @post = Post.find(params[:post_id])
	end
  end
  