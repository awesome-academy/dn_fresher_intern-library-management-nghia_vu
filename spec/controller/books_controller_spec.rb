require "rails_helper"

RSpec.describe BooksController, type: :controller do
  describe "GET #show" do
    let!(:book) {FactoryBot.create :book}

    it "returns a success response" do
      get :show, params: {id: book}
      expect(response).to be_successful
    end

    it "assigns @book when book exist" do
      get :show, params: {id: book}
      expect(assigns(:book)).to eq book
    end

    it "redirect to home path and flash when book does not exist" do
      get :show, params: {id: 0}
      expect(flash[:danger]).to eq I18n.t("books.not_found")
      expect(response).to redirect_to static_pages_home_path
    end
  end
end
