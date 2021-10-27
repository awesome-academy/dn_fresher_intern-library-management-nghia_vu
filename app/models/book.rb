class Book < ApplicationRecord
  belongs_to :shop
  belongs_to :category
  has_many :order_details, dependent: :destroy
  delegate :title, to: :category, prefix: true
  delegate :name, to: :shop, prefix: true

  validates :title, presence: true
  scope :recent_books, ->{order created_at: :desc}
  scope :by_book_ids, ->(ids){where id: ids}

  def self.import file, shop_id
    ActiveRecord::Base.transaction do
      CSV.foreach(file.path, headers: true) do |row|
        row[:shop_id] = shop_id
        Book.create!(row.to_hash)
      end
    end
  end
end
