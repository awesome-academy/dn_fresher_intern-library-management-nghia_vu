FactoryBot.define do
  factory :order do
    total_price{10000}
    name{Faker::Name.initials(number: 10)}
    address{Faker::Address.street_address}
    phone{Faker::PhoneNumber.phone_number}
    shop_id{create(:shop).id}
    user_id{create(:user).id}
  end
end
