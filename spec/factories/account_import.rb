FactoryGirl.define do
  factory :account_import do
    association :account, factory: :account
    association :uploaded_file, factory: :uploaded_file
  end
end
