FactoryBot.define do
  factory :product do
    association :team
    name { "MyString" }
    description { "MyText" }
    url { "MyText" }
  end
end
