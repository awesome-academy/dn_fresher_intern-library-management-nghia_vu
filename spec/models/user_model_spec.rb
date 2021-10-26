RSpec.describe User, type: :model do
  describe "Associations" do
    it "has one shop" do
      is_expected.to have_one(:shop)
    end

    it "has many orders" do
      is_expected.to have_many(:orders)
    end
  end

  describe "Validations" do
    subject { FactoryBot.create :user }
    
    it "is valid with valid attributes" do
        is_expected.to be_valid
    end
    
    it "is not valid without a email" do
	    subject.email = nil
        is_expected.to_not be_valid
    end

    it "is not valid with repeat email" do
      FactoryBot.create :user, email: "a@gmail.com"
      subject.email = "a@gmail.com"
      is_expected.to_not be_valid
    end

    it "is not valid with wrong format email" do
      subject.email = "agmail.com"
      is_expected.to_not be_valid
    end
    
    it "is not valid with too short password" do
        subject.password = "123"
        subject.password_confirmation = "123"
        is_expected.to_not be_valid
    end

    it "is not valid when password confirmation does not match" do
      subject.password = "1231231234"
      is_expected.to_not be_valid
    end
  end

  describe "Methods" do
    let(:user) {FactoryBot.create :user}
    let(:order) {FactoryBot.create :order}

    context "#all_orders" do
      it "return all orders of user" do
        expect(order.user.all_orders).to eq [order]
      end
    end
  end
end
