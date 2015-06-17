FactoryGirl.define do
  factory :account_import do
    association :account, factory: :account
    state 'new'

    before :create do |account_import|
      account_import.uploaded_file = FactoryGirl.create(:uploaded_file, resource: account_import)
    end
  end
end
