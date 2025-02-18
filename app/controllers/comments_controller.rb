class CommentsController < ApplicationController
	def create
	  comment = current_user.comments.build(comment_params)
      if comment.save
	  	flash[:notice] = t('.success')
        redirect_to post_path(comment.post)
      else
	  	flash[:alert] = t('.failure')
        redirect_to post_path(comment.post)
      end
	end
  
	def destroy
	  comment = current_user.comments.find(params[:id])
	  comment.destroy!
	  flash[:notice] = t('.success')
	  redirect_to post_path(comment.post)
	end
  
	private
  
	def comment_params
	  params.require(:comment).permit(:body).merge(post_id: params[:post_id])
	end
  end