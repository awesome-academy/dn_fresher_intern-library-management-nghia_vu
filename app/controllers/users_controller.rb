class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash.now[:danger] = t("users.not_found")
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "welcome"
      sign_in @user
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end
end
