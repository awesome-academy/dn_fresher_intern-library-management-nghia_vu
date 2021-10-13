require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user){FactoryBot.create :user}
  describe "validates" do
    context "name" do
      it "when nil is invalid" do
        expect validate_presence_of(:name).with_message I18n.t("activerecord.errors.models.user.attributes.name.blank")
      end
      it "when too short is invalid" do
        expect validate_length_of(:name).is_at_most(2).with_message I18n.t("activerecord.errors.models.user.attributes.name.too_short")
      end
    end
    context "email" do
      it "when nil is invalid" do
        expect(FactoryBot.build(:user, email: nil)).to be_invalid
      end
      it "must uniqueless" do
        expect validate_uniqueness_of(:email).with_message I18n.t("activerecord.errors.models.user.attributes.email.taken")
      end
      it "when too long is invalid" do
        expect validate_length_of(:email).is_at_most(256).with_message I18n.t("activerecord.errors.models.user.attributes.email.too_long")
      end
      it "when valid format" do
        expect allow_value("example@gmail.com").for(:email)
      end
      it "when invalid format" do
        expect allow_value("examm...@...").for(:email)
                                          .with_message I18n.t("activerecord.errors.models.user.attributes.email.invalid")
      end
    end
    context "password" do
      it "when too short is invalid" do
        expect validate_length_of(:password).is_at_most(2).with_message I18n.t("activerecord.errors.models.user.attributes.password.too_short")
      end
    end
  end

  describe "methods" do    
    context ".digest" do
      it "should return an instance of Bcrypt::Password" do
        expect(User.digest("123123123")).to be_an(BCrypt::Password)
      end
    end
    context ".new_token" do
      it "should return string" do
        expect(User.new_token).to be_an(String)
      end
    end
    context "#remember" do
      it "should update remember digest success" do
        user.remember
        user.reload
        expect(user.remember_digest).to be_truthy
      end
    end
    context "#forget" do
      it "should update remember digest to be nil success" do
        user.forget
        user.reload
        expect(user.remember_digest).to be_nil
      end
    end
    context "#authenticated?" do
      it "should be return false when digest nil" do
        expect(
          user.authenticated? :remember, "123123123"
        ).to eq false
      end
      it "should be return false when digest presence" do
        expect(
          user.authenticated? :remember, User.digest("123123123")
        ).to eq false
      end
    end
  end
end
