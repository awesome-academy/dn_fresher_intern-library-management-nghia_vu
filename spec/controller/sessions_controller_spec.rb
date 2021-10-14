require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    before{get :new}

    it "returns a success response" do
      expect(response).to be_successful
    end

    it "renders the new template" do
			expect(response).to	render_template :new
		end
  end

  describe "POST #create" do
    let!(:user) {FactoryBot.create :user}
    let!(:params) {{session: {email: user.email, password: user.password}}}

    it "redirect to root path when valid attributes" do
      post :create, params: params
      expect(response).to redirect_to root_url
    end

    context "when invalid attributes" do
      before{post :create, params: {session: {email: user.email}}}

      it "renders the new template" do
        expect(response).to render_template :new
      end
  
      it "show flash message" do
        expect(flash[:danger]).to eq I18n.t("users.login.invalid_login")
      end
    end
  end

  describe "GET #destroy" do
    let!(:user) {FactoryBot.create :user}
    let!(:params) {{session: {email: user.email, password: user.password}}}
    
    before { post :create, params: params }

    it "success when redirect to root path" do
      get :destroy
      expect(response).to redirect_to root_url
    end
  end
end
