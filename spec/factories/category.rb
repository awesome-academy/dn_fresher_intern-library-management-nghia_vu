FactoryBot.define do
  factory :category do
    title{Faker::Book.genre}
    description{Faker::Books::Dune.character}
  end
end
