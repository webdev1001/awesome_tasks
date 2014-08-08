FactoryGirl.define do
  factory :user_role do
    role "administrator"
    association :user, factory: :user
  end
end
