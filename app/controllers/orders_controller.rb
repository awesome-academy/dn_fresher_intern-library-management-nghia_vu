class OrdersController < ApplicationController
  before_action :check_user
  before_action :load_order, only: %i(cancel show)
  authorize_resource

  def new
    return unless load_book_id_in_cart.empty?

    flash[:danger] = t "order.cart_empty"
    redirect_to root_path
  end

  def create
    add_infor_receiver
    ActiveRecord::Base.transaction do
      list_shop_id_in_cart.each do |shop_id|
        list_book = list_book_by_shop_id shop_id
        order = create_order shop_id
        add_list_book_to_order_detail list_book, order
        update_order_total_price list_book, order
        order.save!
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "order.failed"
    redirect_to new_user_order_path(current_user)
  else
    reset_cart
    flash[:success] = t "order.success"
    redirect_to root_path
  end

  def index
    @orders = current_user.all_orders.page(params[:page])
                          .per(Settings.length.digit_8)
  end

  def cancel
    if @order.pending?
      @order.cancel!
      flash[:success] = t "order.cancel_success"
    else
      flash[:danger] = t "order.cancel_failed"
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "order.cancel_failed"
  ensure
    redirect_back(fallback_location: root_path)
  end

  def show
    @order_details = @order.order_details.includes(:book)
    @total = total_order @order_details
  end

  private

  def load_order
    @order = current_user.orders.find_by id: params[:id]
    return if @order

    flash[:danger] = t "order.not_found"
    redirect_to static_pages_home_path
  end

  def create_order shop_id
    current_user.orders.build(
      shop_id: shop_id,
      name: params[:name],
      address: params[:address],
      phone: params[:phone]
    )
  end

  def add_list_book_to_order_detail list_book, order
    list_book.each do |book|
      order.order_details.build(
        quantily: current_cart[book["id"].to_s].to_i,
        price: book["price"].to_i,
        book_id: book["id"].to_i
      )
    end
  end

  def update_order_total_price list_book, order
    total = list_book.map{|b| current_cart[b["id"].to_s].to_i * b["price"].to_i}
    order.total_price = total.inject(0, :+)
  end

  def list_shop_id_in_cart
    Book.by_book_ids(load_book_id_in_cart).pluck(:shop_id).uniq
  end

  def list_book_by_shop_id id
    Book.by_book_ids(load_book_id_in_cart).select{|e| e.shop_id == id}
  end

  def add_infor_receiver
    current_info_receiver[:name] = params[:name]
    current_info_receiver[:address] = params[:address]
    current_info_receiver[:phone] = params[:phone]
  end

  def check_user
    if user_signed_in?
      return if current_user.id == params[:user_id].to_i

      flash[:danger] = t "shared.invalid_permision"
      redirect_to root_url
    else
      flash[:danger] = t "please_login"
      redirect_to login_path
    end
  end
end
