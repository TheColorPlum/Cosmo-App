FactoryBot.define do
  factory :feature do
    product { nil }
    name { "MyString" }
    description { "MyText" }
    url { "MyText" }
    cost { 1.5 }
    price { 1.5 }
  end
end
