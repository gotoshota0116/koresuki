FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "test_category_#{n}" }
  end
end
