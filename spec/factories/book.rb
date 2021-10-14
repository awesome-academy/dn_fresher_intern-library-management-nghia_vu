FactoryBot.define do
  factory :book do
    title {Faker::Book.title}
    price {Faker::Number.between(from: 10000, to: 100000)}
    description {Faker::Books::Dune.character}
    quantity {Faker::Number.between(from: 1, to: 20)}
    shop_id {create(:shop).id}
    category_id {create(:category).id}
  end
end
