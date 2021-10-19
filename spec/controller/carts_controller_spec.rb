require "rails_helper"
include SessionsHelper

RSpec.describe CartsController, type: :controller do
  let!(:book) {FactoryBot.create :book}

  describe "GET #index" do
    before do
      session[:cart] = {}
      current_cart[book.id.to_s] = 5
      @books = Book.by_book_ids(load_book_id_in_cart)
      get :index
    end
      
    it "assigns @cart" do
      expect(assigns(:cart)).to eq current_cart
    end

    it "assigns @books" do
      expect(assigns(:books)).to eq @books
    end

    it "renders the index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET #reset" do
    before do
      session[:cart] = {}
      current_cart[book.id.to_s] = 5
      get :reset
    end

    it "redirect to carts path" do
      expect(response).to redirect_to carts_path
    end
  end

  describe "DELETE #destroy" do
    before do
      session[:cart] = {}
      current_cart[book.id.to_s] = 5
      delete :destroy, params: {id: book.id}
    end

    it "redirect to carts path" do
      expect(response).to redirect_to carts_path
    end
  end

  describe "POST #create" do
    context "when book exist" do
      before do
        session[:cart] = {}
        post :create, xhr: true, params: {book_id: book.id, quantity: 5}
      end

      it "has a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when book does not exist" do
      before do
        session[:cart] = {}
        post :create, xhr: true, params: {book_id: 0, quantity: 5}
      end
      
      it "redirect to static pages home path" do
        expect(response).to redirect_to static_pages_home_path
      end

      it "show flash message" do
        expect(flash[:danger]).to eq I18n.t("books.not_found")
      end
    end
  end
end
