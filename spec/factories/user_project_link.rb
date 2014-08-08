FactoryGirl.define do
  factory :user_project_link do
    association :project, factory: :project
    association :user, factory: :user
  end
end
