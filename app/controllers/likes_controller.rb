class LikesController < ApplicationController
  def create
    @likeable = params[:likeable_type].constantize.find(params[:likeable_id])
    pp 999999999999
    pp @likeable
    pp 9999999999
    current_user.like(@likeable)
  end

  def destroy
    @likeable = params[:likeable_type].constantize.find(params[:likeable_id])
    pp 8888888888
    pp @likeable
    pp 88888888888
    current_user.unlike(@likeable)
  end

  # private

  # def set_likeable
  #   @likeable = params[:likeable_type].constantize.find(params[:likeable_id])
  # end
end
