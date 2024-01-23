FactoryBot.define do
  factory :note do
    association :team
    title { "MyString" }
    body { "MyText" }
  end
end
