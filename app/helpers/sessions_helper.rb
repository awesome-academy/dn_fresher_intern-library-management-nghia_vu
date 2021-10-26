module SessionsHelper
  def load_book_id_in_cart
    current_cart.keys
  end

  def reset_cart
    current_cart.clear
  end

  def delete_cart_item id
    current_cart.delete(id.to_s)
  end

  def add_book_to_cart book_id, quantity
    current_cart.delete(book_id.to_s)
    current_cart[book_id.to_s.to_sym] = quantity
  end

  def current_cart
    @current_cart ||= session[:cart]
  end

  def current_info_receiver
    @current_info_receiver ||= session[:info_receiver]
  end

  def load_param_name
    if current_info_receiver.any?
      current_info_receiver["name"]
    else
      current_user.name
    end
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
