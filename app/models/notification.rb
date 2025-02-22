class Notification < ApplicationRecord
	belongs_to :visitor, class_name: 'User'
	belongs_to :visited, class_name: 'User'
	belongs_to :notifiable, polymorphic: true
  
	validates :action, presence: true
	validates :checked, inclusion: { in: [true, false] }
  
	enum action: { liked: 0, commented: 1 }
  end