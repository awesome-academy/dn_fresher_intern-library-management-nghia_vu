RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    before{get :new}

    it "returns a success response" do
      expect(response).to be_successful
    end

    it "assigns @user" do
      expect(assigns(:user)) == User.new
    end

    it "renders the new template" do
		  expect(response).to	render_template :new
		end
  end

  describe "POST #create" do
    let(:user_params_valid) {{name: "asdasdasd123", email: "a@gmail.com",
      password: "123123123", password_confirmation: "123123123"}}
    let(:user_params_invalid) {{name: "a"}}

    it "redirect to root path and flash when valid attributes" do
      post :create, params: {user: user_params_valid}
      expect(response).to redirect_to root_url
    end

    it "renders the new template when invalid attributes" do
      post :create, params: {user: user_params_invalid}
      expect(response).to render_template :new
    end
  end
end
