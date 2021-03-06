FactoryGirl.define do
  factory :invoice do
    amount 0.0
    date "2014-06-17"
    invoice_type "debit"
    invoice_no 123
    payment_at "2014-06-24"

    association :organization, factory: :organization
    association :creditor, factory: :organization
    association :user, factory: :user
  end
end
