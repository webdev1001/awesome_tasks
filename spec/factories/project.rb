FactoryGirl.define do
  factory :project do
    name { Forgery(:lorem_ipsum).words(2) }
    association :customer, :factory => :customer
  end
end
