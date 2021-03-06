FactoryBot.define do
  factory :user do
    sequence(:user_name) { |n| "TEST_NAME#{n}" }
    sequence(:email) { |n| "TEST#{n}@example.com" }
    sequence(:password) { 'password' }
  end
end
