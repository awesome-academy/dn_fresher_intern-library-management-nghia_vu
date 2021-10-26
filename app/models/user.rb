class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum status: {member: 0, admin: 1}
  has_many :orders, dependent: :destroy
  has_one :shop, dependent: :destroy

  validates :name, presence: true, length: {minimum: Settings.length.digit_10}

  def all_orders
    orders.recent_orders
  end
end
