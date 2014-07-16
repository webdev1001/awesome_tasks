FactoryGirl.define do
  factory :timelog do
    association :task, factory: :task
    association :user, factory: :user
  end
end
