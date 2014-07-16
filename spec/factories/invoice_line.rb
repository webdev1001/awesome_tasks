FactoryGirl.define do
  factory :invoice_line do
    title { Forgery(:lorem_ipsum).words(4) }
    amount 100.0
    quantity 1

    association :invoice, factory: :invoice
  end
end
