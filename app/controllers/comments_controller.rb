class CommentsController < ApplicationController
  def create
    # @post,@commentsはpots/showをレンダリングするために定義
    @post = Post.find(params[:post_id])
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = current_user.comments.build(comment_params)
    @current_user_likes = current_user.present? ? current_user.likes.where(likeable_type: 'Comment').index_by(&:likeable_id) : {}
    if @comment.save
      @comment.create_notification(current_user, :commented)
      flash[:notice] = t('defaults.flash_message.created', item: Comment.model_name.human)
      redirect_to post_path(@comment.post)
    else
      render 'posts/show', status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!
    flash[:notice] = t('defaults.flash_message.deleted', item: Comment.model_name.human)
    redirect_to post_path(comment.post)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
