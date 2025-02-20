class LikesController < ApplicationController
  def create
    @likeable = params[:likeable_type].constantize.find(params[:likeable_id])
    current_user.like(@likeable)
  end

  def destroy
    @likeable = current_user.likes.find(params[:id]).likeable
    current_user.unlike(@likeable)
  end
end
