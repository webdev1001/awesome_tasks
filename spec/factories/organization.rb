FactoryGirl.define do
  factory :organization do
    name { Forgery(:lorem_ipsum).words(2) }
    email { Forgery(:internet).email_address }
  end
end
