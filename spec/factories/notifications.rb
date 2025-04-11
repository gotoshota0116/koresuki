FactoryBot.define do
  factory :notification do
    association :visitor, factory: :user
    association :visited, factory: :user
    association :notifiable, factory: :post
    action { 'liked' }
    checked { false }
  end
end
