FactoryBot.define do
  factory :shop do
    name{Faker::Name.name}
    description{"shop chuyen"}
    user_id{create(:user).id}
  end
end
