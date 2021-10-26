RSpec.shared_examples "login examples" do
  let!(:order) {FactoryBot.create :order}
  before{get :index, params: {user_id: order.user.id}}

  it "show flash message" do
    expect(flash[:alert]).to eq I18n.t("devise.failure.unauthenticated")
  end

  it "redirect to login_path" do
    expect(response).to be_successful
  end
end
