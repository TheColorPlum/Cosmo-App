FactoryBot.define do
  factory :content do
    association :team
    title { "MyString" }
    description { "MyText" }
    url { "MyText" }
    active { false }
  end
end
