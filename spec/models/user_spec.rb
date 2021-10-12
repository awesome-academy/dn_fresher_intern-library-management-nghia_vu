require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user){FactoryBot.create :user}
  describe "validates" do
    context "name" do
      it "when length too short" do
        is_expected.to validate_length_of(:name).is_at_most(2).with_message I18n.t("activerecord.errors.user.name.too_short")
      end
    end
  end
end