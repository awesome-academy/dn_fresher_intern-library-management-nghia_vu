FactoryBot.define do
  factory :shop do
    name{Faker::Name.name}
    description{Faker::Books::Dune.character}
    user_id{create(:user).id}
  end
end
