class StaticPagesController < ApplicationController
  def home
    @q = Book.ransack(params[:q])
    @books = @q.result
               .recent_books
               .page(params[:page]).per(Settings.page.per_page_6)
  end
end
