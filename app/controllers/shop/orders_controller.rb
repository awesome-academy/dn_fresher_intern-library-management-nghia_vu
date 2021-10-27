class Shop::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_shop, only: %i(index show approve disclaim)
  before_action :load_order, only: %i(show approve disclaim)
  before_action :check_quantity, only: :approve
  before_action :check_user, only: %i(index show approve disclaim)
  authorize_resource

  def index
    @orders = @shop.all_orders
                   .page(params[:page]).per(Settings.length.digit_10)
  end

  def show
    @order_details = @order.order_details.includes(:book)
    @total = total_order @order_details
  end

  def approve
    ActiveRecord::Base.transaction do
      if @order.pending?
        update_quantity @order
        @order.success!
        flash[:success] = t "order.approve_success"
      else
        flash[:danger] = t "order.approve_failed"
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "order.approve_failed"
  ensure
    redirect_back(fallback_location: root_path)
  end

  def disclaim
    if @order.pending?
      @order.disclaim!
      flash[:success] = t "order.disclaim_success"
    else
      flash[:danger] = t "order.disclaim_failed"
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "order.disclaim_failed"
  ensure
    redirect_back(fallback_location: root_path)
  end

  private

  def update_quantity order
    list_order_detail = order.order_details
    list_order_detail.each do |order_detail|
      book = order_detail.book
      book.quantity -= order_detail.quantily
      book.save!
    end
  end

  def check_quantity
    list_order_detail = @order.order_details
    book_fail = []
    list_order_detail.each do |order_detail|
      if order_detail.book.quantity < order_detail.quantily
        book_fail.push(order_detail.book.id)
      end
    end
    return if book_fail.blank?

    flash[:danger] = t("order.list_book_failed") << book_fail.to_s
    redirect_back(fallback_location: root_path)
  end

  def load_order
    @order = @shop.orders.find_by id: params[:id]
    return if @order

    flash[:danger] = t "order.not_found"
    redirect_to root_url
  end

  def load_shop
    @shop = current_user.shop
    return if @shop.present?

    flash[:danger] = t("shops.not_found")
    redirect_to root_url
  end

  def check_user
    return if current_user.id == params[:user_id].to_i

    flash[:danger] = t "shared.invalid_permision"
    redirect_to root_url
  end
end
