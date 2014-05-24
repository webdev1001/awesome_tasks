FactoryGirl.define do
  factory :task do
    name { Forgery(:lorem_ipsum).words(4) }
    association :user, :factory => :user
    association :project, :factory => :project
    description { Forgery(:lorem_ipsum).words(100) }
  end
end
