class StaticPagesController < ApplicationController
  skip_authorize_resource
  def home
    @books = Book.recent_books
                 .seach_by_title(params[:search])
                 .page(params[:page]).per(Settings.page.per_page_6)
  end
end
