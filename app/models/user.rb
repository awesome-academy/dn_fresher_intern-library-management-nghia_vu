class User < ApplicationRecord
  enum status: {member: 0, admin: 1}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: {minimum: Settings.length.digit_10}
  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.length.digit_255},
    format: {with: VALID_EMAIL_REGEX}
  validates :password, length: {minimum: Settings.length.digit_8}
  has_secure_password

  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end
end
