FactoryBot.define do
  factory :order do
    total_price{10000}
    name{"nghia"}
    address{"123 DN"}
    phone{"0123123123"}
    shop_id{create(:shop).id}
    user_id{create(:user).id}
  end
end
