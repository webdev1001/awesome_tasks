FactoryGirl.define do
  factory :invoice do
    amount 0.0
    title { Forgery(:lorem_ipsum).words(4) }
    date "2014-06-17"
    invoice_type "debit"
    invoice_no 123
    payment_at "2014-06-24"
    
    association :customer, :factory => :customer
    association :creditor, :factory => :customer
    association :user, :factory => :user
  end
end
