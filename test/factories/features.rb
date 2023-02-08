FactoryBot.define do
  factory :feature do
    association :product
    name { "MyString" }
    description { "MyText" }
    url { "MyText" }
    cost { 1.5 }
    price { 1.5 }
  end
end
