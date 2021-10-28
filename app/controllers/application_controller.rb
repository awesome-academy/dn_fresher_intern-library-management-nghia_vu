class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  authorize_resource unless: :devise_controller?

  before_action :set_locale, :load_cart, :load_info_receiver
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Catch all CanCan errors and alert the user of the exception
  rescue_from CanCan::AccessDenied, with: :access_denied
  include SessionsHelper
  include OrdersHelper

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_cart
    session[:cart] ||= {}
  end

  def load_info_receiver
    session[:info_receiver] ||= {}
  end

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation,
      :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def access_denied
    flash[:danger] = t "shared.invalid_permision"
    redirect_to root_url
  end
end
