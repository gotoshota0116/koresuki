FactoryBot.define do
  factory :comment do
    body { 'test_comment' }
    association :user
    association :post
  end
end
