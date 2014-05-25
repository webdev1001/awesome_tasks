FactoryGirl.define do
  factory :customer do
    name { Forgery(:lorem_ipsum).words(2) }
  end
end
