FactoryGirl.define do
  factory :invoice_group do
    name { Forgery(:lorem_ipsum).words(3) }
  end
end
