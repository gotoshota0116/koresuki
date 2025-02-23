class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications
                                # 通知を送ったuser、通知対象(postやcomment)を取得するためincludes
                               .includes(:visitor, :notifiable)
                               .order(created_at: :desc)
    @notifications.where(checked: false).update_all(checked: true)
  end
end
