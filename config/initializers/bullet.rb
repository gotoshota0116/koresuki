Bullet.add_safelist type: :unused_eager_loading, class_name: 'Notification', association: :visitor if defined?(Bullet)
Bullet.add_safelist type: :unused_eager_loading, class_name: 'Post', association: :post_videos if defined?(Bullet)
Bullet.add_safelist type: :unused_eager_loading, class_name: 'Post', association: :user if defined?(Bullet)