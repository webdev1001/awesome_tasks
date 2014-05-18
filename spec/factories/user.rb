FactoryGirl.define do
  factory :user do
    name { Forgery::Name.full_name }
    username { Forgery(:lorem_ipsum).words(2) }
    email { Forgery(:internet).email_address }
    password { Forgery(:lorem_ipsum).words(4) }
    locale "en"
  end
  
  factory :user_admin, :class => "User" do
    name { Forgery::Name.full_name }
    username { Forgery(:lorem_ipsum).words(2) }
    email { Forgery(:internet).email_address }
    password { Forgery(:lorem_ipsum).words(4) }
    locale "en"
    
    after(:create) do |user|
      user.user_roles.create(:role => "administrator")
    end
  end
end
