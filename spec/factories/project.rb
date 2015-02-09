FactoryGirl.define do
  factory :project do
    name { Forgery(:lorem_ipsum).words(2) }
    price_per_hour 350
    price_per_hour_transport 150
    association :organization, factory: :organization
  end
end
