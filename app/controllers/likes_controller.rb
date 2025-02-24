class LikesController < ApplicationController
  before_action :set_likeable, only: %i[create destroy]

  def create
    current_user.like(@likeable)
    @likeable.create_notification(current_user, :liked)
    # create.turbo_stream.erbで、like-button-#{@likeable.id}を更新する
  end

  def destroy
    current_user.unlike(@likeable)
    # destroy.turbo_stream.erbで、unlike-button-#{@likeable.id}を更新する
  end

  private

  def set_likeable
    @likeable = params[:likeable_type].constantize.find(params[:likeable_id])
  end
end
