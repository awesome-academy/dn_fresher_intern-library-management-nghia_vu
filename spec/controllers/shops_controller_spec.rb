require "rails_helper"
include SessionsHelper

RSpec.describe ShopsController, type: :controller do
  describe "GET #index" do
    let!(:shop_1){FactoryBot.create :shop}
    let!(:shop_2){FactoryBot.create :shop}
    context "when search value is nil" do
      before do
        get :index, params: { q: {
          name_cont: ""
        }}
      end
      it "render index" do
        expect(response).to render_template(:index)
      end
      it "does not render different template" do
        expect(response).to_not render_template(:show)
      end
      it "return all shop" do
        expect(assigns(:shops)).to eq [shop_1, shop_2]
      end
    end

    context "when search value is shop_2" do
      before do
        get :index, params: { q: {
          name_cont: shop_2.name
        }}
      end
      it "render index" do
        expect(response).to render_template(:index)
      end
      it "does not render different template" do
        expect(response).to_not render_template(:show)
      end
      it "return shop_2" do
        expect(assigns(:shops)).to eq [shop_2]
      end
    end
  end

  describe "GET #new" do
    context "when user login" do
      before do
        @user = FactoryBot.create :user
        sign_in @user
      end
      context "when valid user" do
        before do
          get :new, params: {user_id: @user.id}
        end
        it "render new" do
          expect(response).to render_template(:new)
        end
        it "does not render different template" do
          expect(response).to_not render_template(:show)
        end
      end
  
      context "when invalid user" do
        before do
          get :new, params: {user_id: -1}
        end
        it "return flash danger" do
          expect(flash[:danger]).to eq I18n.t("shared.invalid_permision")
        end
        it "redirects to root_url" do
          expect(response).to redirect_to root_url
        end
      end
    end

    context "when user not login" do
      before do
        get :new, params: {user_id: 1}
      end
      it "return flash danger" do
        expect(flash[:danger]).to eq I18n.t("please_login")
      end
      it "redirects to login" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context "when user login" do
      before do
        @user = FactoryBot.create :user
        sign_in @user
      end
  
      context "when valid user" do
        context "when valid params" do
          before do
            post :create, params: { shop: {
              name: Faker::Book.name,
              description: "Manga hay hay"
            }, user_id: @user.id}
          end
          it "redirects to the users" do
            expect(response).to redirect_to user_shop_shops_path(@user.id)
          end
          it "display flash message" do
            expect(flash[:success]).to eq I18n.t("shops.success")
          end
        end
    
        context "when invalid params" do
          before do
            post :create, params: { shop: {
              name: "",
              description: "Manga hay hay"
            }, user_id: @user.id}
          end
          it "render new" do
            expect(response).to render_template :new
          end
        end
      end

      context "when invalid user" do
        before do
          post :create, params: { shop: {
            name: Faker::Book.name,
            description: "Manga hay hay"
          }, user_id: -1}
        end
        it "return flash danger" do
          expect(flash[:danger]).to eq I18n.t("shared.invalid_permision")
        end
        it "redirects to root_url" do
          expect(response).to redirect_to root_url
        end
      end
    end

    context "when user not login" do
      before do
        post :create, params: { shop: {
          name: Faker::Book.name,
          description: "Manga hay hay"
        }, user_id: 4}
      end
      it "return flash danger" do
        expect(flash[:danger]).to eq I18n.t("please_login")
      end
      it "redirects to login" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #show" do
    context "when shop exist" do
      let!(:shop) {FactoryBot.create :shop}
      before{get :show, params: {id: shop.id}}
      it "assigns @books" do
        expect(assigns(:books)).to eq shop.all_books
      end
      it "renders the show template" do
        expect(response).to render_template :show
      end
    end

    context "when shop does not exist" do
      before do
        get :show, params: {id: -1}
      end
      it "redirect to root url" do
        expect(response).to redirect_to root_url
      end
      it "display flash message" do
        expect(flash[:danger]).to eq I18n.t("shops.not_found")
      end
    end 
  end
end
