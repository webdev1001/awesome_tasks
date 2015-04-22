FactoryGirl.define do
  factory :uploaded_file do
    title { Forgery::LoremIpsum.words(3) }
    file { fixture_file_upload(Rails.root.join("spec/images/kaspernj.jpg"), "image/jpeg") }

    association :user, factory: :user
    association :resource, factory: :invoice
  end
end
