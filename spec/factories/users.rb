FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "example_#{n}@email.com" }
    password { "password" }
    password_confirmation { "password"}
  end
end