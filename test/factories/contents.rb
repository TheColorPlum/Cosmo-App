FactoryBot.define do
  factory :content do
    team { nil }
    title { "MyString" }
    description { "MyText" }
    url { "MyText" }
    active { false }
  end
end
