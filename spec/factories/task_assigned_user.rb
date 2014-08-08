FactoryGirl.define do
  factory :task_assigned_user do
    association :task, factory: :task
    association :user, factory: :user
  end
end
