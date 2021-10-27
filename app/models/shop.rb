class Shop < ApplicationRecord
  belongs_to :user
  has_many :books, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :description, length: {maximum: Settings.length.digit_255}

  def all_books
    books.recent_books
  end

  def all_orders
    orders.recent_orders
  end
end
