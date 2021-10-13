FactoryBot.define do
  factory :user do
    name{Faker::Name.name_with_middle}
    email{Faker::Internet.email.downcase}
    password{"123123123"}
    password_confirmation{"123123123"}
  end
end
