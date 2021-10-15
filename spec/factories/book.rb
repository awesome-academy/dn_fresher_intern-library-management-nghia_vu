FactoryBot.define do
  factory :book do
    title {"manga"}
    price {1000}
    description {"hay lam hihi"}
    quantity {10}
    shop_id {create(:shop).id}
    category_id {create(:category).id}
  end
end
