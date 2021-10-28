class CartsController < ApplicationController
  before_action :load_book, only: :create
  skip_authorize_resource 

  def index
    @books = Book.by_book_ids(load_book_id_in_cart)
    @cart = current_cart
    store_location
  end

  def create
    add_book_to_cart(params[:book_id], params[:quantity]) if check_quantity
    respond_to do |format|
      format.js
    end
  end

  def destroy
    delete_cart_item params[:id]
    redirect_to carts_path
  end

  def reset
    reset_cart
    redirect_to carts_path
  end

  private

  def check_quantity
    @quantity = @book.quantity >= params[:quantity].to_i
  end

  def load_book
    @book = Book.find_by id: params[:book_id]
    return if @book

    flash[:danger] = t "books.not_found"
    redirect_to static_pages_home_path
  end
end
