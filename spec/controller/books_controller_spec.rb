RSpec.describe BooksController, type: :controller do
  describe "GET #show" do
    let!(:book) {FactoryBot.create :book}

    context "when book exist" do
      before{get :show, params: {id: book}}

      it "returns a success response" do
        expect(response).to be_successful
      end
  
      it "assigns @book" do
        expect(assigns(:book)).to eq book
      end
    end

    context "when book does not" do
      before{get :show, params: {id: 0}}

      it "redirect to home path" do
        expect(response).to redirect_to static_pages_home_path
      end

      it "show flash message" do
        expect(flash[:danger]).to eq I18n.t("books.not_found")
      end
    end
  end
end
