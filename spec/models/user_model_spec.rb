RSpec.describe User, type: :model do
  describe "Associations" do
    it "has one shop" do
      association = described_class.reflect_on_association(:shop)
      expect(association.macro).to eq :has_one
    end

    it "has many orders" do
      association = described_class.reflect_on_association(:orders)
      expect(association.macro).to eq :has_many
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

    context ".new_token" do
      it "return string" do
        expect(User.new_token).to be_an(String)
      end
    end

    context "#remember" do
      it "update remember digest" do
        user.remember
        expect(user.remember_digest).to be_truthy
      end
    end

    context "#authenticated?" do
      it "return false when digest nil" do
        expect(
          user.authenticated? :remember, "123123123"
        ).to eq false
      end

      it "return true when digest presence" do
        user.remember
        expect(
          user.authenticated? :remember, user.remember_token
        ).to eq true
      end
    end

    context "#forget" do
      it "update remember to nil" do
        user.forget
        expect(user.remember_digest).to be_nil
      end
    end
  end
end
