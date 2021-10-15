require "rails_helper"
include SessionsHelper
include OrdersHelper

RSpec.describe OrdersController, type: :controller do
  describe "GET #new" do
    context "when cart has item" do
      before do
        @user = User.create!(name: "asdasdasdasd",
          email: "a@mail.com",
          password: "123123123",
          password_confirmation: "123123123")
        log_in @user
        session[:cart] = {}
        current_cart["1"] = 1
        get :new, params: {user_id: @user.id}
      end
      
      it "returns a success response" do
        expect(response).to be_successful
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end

    context "when cart empty" do
      before do
        @user = User.create!(name: "asdasdasdasd",
          email: "a@mail.com",
          password: "123123123",
          password_confirmation: "123123123")
        log_in @user
        session[:cart] = {}
        get :new, params: {user_id: @user.id}
      end

      it "redirect to root path and flash" do
        expect(flash[:danger]).to eq I18n.t("order.cart_empty")
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "POST #create" do
    context "when delivery information valid" do
      let!(:book) {FactoryBot.create :book}
      before do
        @user = User.create!(name: "asdasdasdasd",
          email: "a@mail.com",
          password: "123123123",
          password_confirmation: "123123123")
        log_in @user
        session[:cart] = {}
        current_cart[book.id.to_s] = 1
        post :create, params: {user_id: @user.id, name: "nghia", address: "123 DN", phone: "0123123123"}
      end
      
      it "redirect to root url and flash" do
        expect(flash[:success]).to eq I18n.t("order.success")
        expect(response).to redirect_to root_url
      end
    end

    context "when delivery information invalid" do
      let!(:book) {FactoryBot.create :book}
      before do
        @user = User.create!(name: "asdasdasdasd",
          email: "a@mail.com",
          password: "123123123",
          password_confirmation: "123123123")
        log_in @user
        session[:cart] = {}
        current_cart[book.id.to_s] = 1
        post :create, params: {user_id: @user.id, name: "nghia"}
      end
      
      it "redirect to new user order path and flash" do
        expect(flash[:danger]).to eq I18n.t("order.failed")
        expect(response).to redirect_to new_user_order_path(current_user)
      end
    end
  end

  describe "GET #index" do
    let!(:order) {FactoryBot.create :order}
    before do
      log_in order.user
      @orders = current_user.all_orders
      get :index, params: {user_id: order.user.id}
    end
      
    it "assigns @orders" do
      expect(assigns(:orders)).to eq @orders
    end

    it "renders the index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    context "when order exist" do
      let!(:book) {FactoryBot.create :book}
      let!(:order) {FactoryBot.create :order}
      before do
        log_in order.user
        order.order_details.create!(quantily: 10,
          price: 10000,
          book_id: book.id) 
        @order_details = order.order_details.includes(:book)
        @total = total_order @order_details
        get :show, params: {user_id: order.user.id, id: order.id }
      end
      
      it "assigns @order_details @total" do
        expect(assigns(:order_details)).to eq @order_details
        expect(assigns(:total)).to eq @total
      end

      it "renders the show template" do
        expect(response).to render_template :show
      end
    end

    context "when order does not exist" do
      let!(:order) {FactoryBot.create :order}
      before do
        log_in order.user
        get :show, params: {user_id: order.user.id, id: 0 }
      end
      
      it "redirect to static pages home path and flash" do
        expect(flash[:danger]).to eq I18n.t("order.not_found")
        expect(response).to redirect_to static_pages_home_path
      end
    end
  end

  describe "PUT #cancel" do
    context "when order pending" do
      let!(:order) {FactoryBot.create :order}
      before do
        log_in order.user
        put :cancel, params: {user_id: order.user.id, id: order.id }
      end
      
      it "redirect back and flash" do
        expect(flash[:success]).to eq I18n.t("order.cancel_success")
        expect(response).to redirect_to root_path
      end
    end

    context "when order is not pending" do
      let!(:order) {FactoryBot.create :order}
      before do
        log_in order.user
        order.cancel!
        put :cancel, params: {user_id: order.user.id, id: order.id }
      end
      
      it "redirect back and flash" do
        expect(flash[:danger]).to eq I18n.t("order.cancel_failed")
        expect(response).to redirect_to root_path
      end
    end
  end
end
