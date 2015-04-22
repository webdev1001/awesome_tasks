FactoryGirl.define do
  association :account, factory: :account

  text { Forgery::LoremIpsum.words(3, random: true) }
  rent_at 3.days.ago
  booked_at 2.days.ago
  amount 125.5
end
