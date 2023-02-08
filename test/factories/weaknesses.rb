FactoryBot.define do
  factory :weakness do
    association :feature
    name { "MyString" }
    description { "MyText" }
    category { "MyString" }
  end
end
