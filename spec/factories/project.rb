FactoryGirl.define do
  factory :project do
    name { Forgery(:lorem_ipsum).words(2) }
    association :organization, :factory => :organization
  end
end
