class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications
                               .includes(:visitor, :notifiable)
                               .order(created_at: :desc)
    @notifications.where(checked: false).update_all(checked: true)
  end
end
