FactoryGirl.define do
  factory :task_check do
    name { Forgery::LoremIpsum.words(5) }
    description { Forgery::LoremIpsum.words(30) }

    association :task, factory: :task
    association :user_added, factory: :user
  end
end
