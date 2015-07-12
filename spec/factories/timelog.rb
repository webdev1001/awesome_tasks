FactoryGirl.define do
  factory :timelog do
    association :task, factory: :task
    association :user, factory: :user

    time "02:00:00"
    time_transport "00:30:00"
    comment { Forgery::LoremIpsum.words(8, random: true) }
  end
end
