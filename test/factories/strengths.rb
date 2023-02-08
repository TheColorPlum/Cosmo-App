FactoryBot.define do
  factory :strength do
    association :feature
    name { "MyString" }
    description { "MyText" }
    category { "MyString" }
  end
end
