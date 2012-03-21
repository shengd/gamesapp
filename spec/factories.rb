FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@email.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
end
