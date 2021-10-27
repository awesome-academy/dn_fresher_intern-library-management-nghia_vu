class ShopsController < ApplicationController
  before_action :load_shop, only: :show
  before_action :check_user, only: %i(new create)
  authorize_resource

  def index
    @shops = Shop.search_by_name(params[:search])
                 .page(params[:page]).per(Settings.length.digit_6)
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = current_user.build_shop(shop_params)
    if @shop.save
      flash[:success] = t "shops.success"
      redirect_to user_shop_shops_path(current_user.id)
    else
      flash.now[:danger] = t "shops.fail"
      render :new
    end
  end

  def show
    @books = @shop.all_books
                  .page(params[:page]).per(Settings.length.digit_5)
  end

  private

  def load_shop
    @shop = Shop.find_by id: params[:id]
    return if @shop

    flash[:danger] = t("shops.not_found")
    redirect_to root_url
  end

  def shop_params
    params.require(:shop).permit(:name, :description)
  end

  def check_user
    if user_signed_in?
      return if current_user.id == params[:user_id].to_i

      flash[:danger] = t "shared.invalid_permision"
      redirect_to root_url
    else
      flash[:danger] = t "please_login"
      redirect_to new_user_session_path
    end
  end
end
