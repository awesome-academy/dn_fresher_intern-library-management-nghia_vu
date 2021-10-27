# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :read, [Book, Shop]
    can :create, Order
    return unless user

    can [:read, :cancel], Order, user_id: user.id
    if user.shop.present?
      can :update, Shop, user_id: user.id
      can :manage, Book, shop_id: user.shop.id
      can :manage, Order, shop_id: user.shop.id
    else
      can :create, Shop
    end
  end
end
