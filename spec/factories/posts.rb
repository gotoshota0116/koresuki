FactoryBot.define do
  factory :post do
    association :user
    title { 'test_title' }
    body { 'test_body' }

    after(:build) do |post|
      post.categories << build(:category)
    end
  end
end
