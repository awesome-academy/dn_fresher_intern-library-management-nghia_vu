RSpec.shared_examples "login examples" do
  let!(:order) {FactoryBot.create :order}
  before{get :index, params: {user_id: order.user.id}}

  it "show flash message" do
    expect(flash[:danger]).to eq I18n.t("please_login")
  end

  it "redirect to login_path" do
    expect(response).to be_successful
  end
end
