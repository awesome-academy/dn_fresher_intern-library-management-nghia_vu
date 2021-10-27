class BooksController < ApplicationController
  before_action :load_book, only: :show
  authorize_resource

  def show; end

  private

  def load_book
    @book = Book.find_by id: params[:id]
    return if @book

    flash[:danger] = t "books.not_found"
    redirect_to static_pages_home_path
  end
end
