FactoryGirl.define do
  factory :comment do
    association :resource, :factory => :task
    association :user, :factory => :user
    comment { Forgery(:lorem_ipsum).words(50) }
  end
end
