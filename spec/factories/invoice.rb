FactoryGirl.define do
  factory :invoice do
    amount 0.0
    title { Forgery(:lorem_ipsum).words(4) }
    date "2014-06-17"
    invoice_type "debit"
    
    association :customer, :factory => :customer
    association :user, :factory => :user
  end
end
