FactoryGirl.define do
  factory :account do
    name { Forgery::LoremIpsum.words(2, random: true) }
  end
end
