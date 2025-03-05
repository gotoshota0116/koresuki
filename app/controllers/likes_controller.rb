class LikesController < ApplicationController
  before_action :set_likeable, only: %i[create destroy]

  # create.turbo_stream.erbで、like-button-#{@likeable.id}を更新する
  def create
    current_user.like(@likeable) # いいねを作成
    @likeable.create_notification(current_user, :liked) # 通知を作成
    # create後の_unlike_buttonをレンダリングするたため、@current_user_likesを定義
    @current_user_likes = current_user.present? ? current_user.likes.where(likeable_type: %w[Post Comment]).index_by(&:likeable_id) : {}
  end

  # destroy.turbo_stream.erbで、unlike-button-#{@likeable.id}を更新する
  def destroy
    current_user.unlike(@likeable)
  end

  private

  def set_likeable
    @likeable = params[:likeable_type].constantize.find(params[:likeable_id])
  end
end
