FactoryBot.define do
  factory :post do
    title { 'test_title' }
    body { 'test_body' }
    # association :user

    after(:build) do |post|
      post.categories << build(:category)
    end
  end
end
