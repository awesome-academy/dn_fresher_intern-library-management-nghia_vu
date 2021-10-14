require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #home" do
    let!(:book1) {FactoryBot.create :book}
    let!(:book2) {FactoryBot.create :book}

    before{get :home}
    
    it "returns a success response" do
      expect(response).to be_successful
    end

    it "assigns @books" do
      expect(assigns(:books)).to eq([book2, book1])
      end

    it "renders the home template" do
      expect(response).to render_template(:home)
    end
  end
end