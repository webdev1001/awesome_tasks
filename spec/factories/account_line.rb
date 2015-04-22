FactoryGirl.define do
  factory :account_line do
    association :account, factory: :account

    text { Forgery::LoremIpsum.words(3, random: true) }
    interest_at 3.days.ago
    booked_at 2.days.ago
    amount 125.5
  end
end
