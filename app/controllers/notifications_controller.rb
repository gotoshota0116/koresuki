class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications
                                # 通知を送ったuser、通知対象(postやcomment)を取得するためincludes
                                .includes(:visitor, { notifiable: [:post, :comment] })
                                .order(created_at: :desc)
    @notifications.where(checked: false).update_all(checked: true)
  end

  def destroy
    current_user.passive_notifications.destroy_all
    redirect_to notifications_path, notice: t('defaults.flash_message.deleted', item: Notification.model_name.human)
  end
end
