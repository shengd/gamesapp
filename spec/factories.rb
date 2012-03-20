FactoryGirl.define do
  factory :user do
    login "foobar"
    email "baz@quux.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
