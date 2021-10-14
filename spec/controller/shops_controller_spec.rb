require "rails_helper"
include SessionsHelper

RSpec.describe ShopsController, type: :controller do
  describe "GET #new" do
    context "when user_id valid" do
      before do
        @user = User.create!(name: "asdasdasdasd",
          email: "a@mail.com",
          password: "123123123",
          password_confirmation: "123123123")
        log_in @user
        get :new, params: {user_id: @user.id}
      end
  
      it "returns a success response" do
        expect(response).to be_successful
      end
  
      it "assigns @shop" do
        expect(assigns(:shop)) == Shop.new
      end
  
      it "renders the new template" do
        expect(response).to	render_template :new
      end
    end 

    context "when user_id invalid" do
      before do
        @user = User.create!(name: "asdasdasdasd",
            email: "a@mail.com",
            password: "123123123",
            password_confirmation: "123123123")
        log_in @user
      end

      it "redirect to root url and flash" do
        get :new, params: {user_id: 0}
        expect(flash[:danger]).to eq I18n.t("shared.invalid_permision")
        expect(response).to redirect_to root_url
      end
    end 
  end

  describe "POST #create" do
    context "when valid attributes" do
      before do
        @user = User.create!(name: "asdasdasdasd",
          email: "a@mail.com",
          password: "123123123",
          password_confirmation: "123123123")
        log_in @user
        post :create, params: {user_id: @user.id, shop:{name: "asdasdasd", description:"zxczxczxc"}}
      end
      
      it "redirect to user shop shops path and flash" do
        expect(flash[:success]).to eq I18n.t("shops.success")
        expect(response).to redirect_to user_shop_shops_path(current_user.id)
      end
    end

    context "when invalid attributes" do
      let!(:shop) {FactoryBot.create :book}
      before do
        @user = User.create!(name: "asdasdasdasd",
          email: "a@mail.com",
          password: "123123123",
          password_confirmation: "123123123")
        log_in @user
        post :create, params: {user_id: @user.id, shop:{name: "", description:"zxczxczxc"}}
      end
      
      it "render the new template and flash" do
        expect(flash[:danger]).to eq I18n.t("shops.fail")
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #index" do
    let!(:shop) {FactoryBot.create_list :shop, 2}
    before do
      get :index, params: {search: ""}
    end
      
    it "assigns @shops" do
      expect(assigns(:shops)).to eq [shop[0], shop[1]]
    end

    it "renders the index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    context "when shop exist" do
      let!(:shop) {FactoryBot.create :shop}
      before{get :show, params: {id: shop}}

      it "returns a success response" do
        expect(response).to be_successful
      end
  
      it "assigns @books" do
        expect(assigns(:books)).to eq shop.all_books
      end

      it "renders the show template" do
        expect(response).to render_template :show
      end
    end
    
    context "when shop does not exist" do
      let!(:shop) {FactoryBot.create :shop}

      it "redirect to root url and flash" do
        get :show, params: {id: 0}
        expect(flash[:danger]).to eq I18n.t("shops.not_found")
        expect(response).to redirect_to root_url
      end
    end 
  end
end
