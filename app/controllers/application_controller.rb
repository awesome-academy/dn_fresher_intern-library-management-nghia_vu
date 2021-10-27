class ApplicationController < ActionController::Base
  before_action :set_locale, :load_cart, :load_info_receiver
  rescue_from ActiveRecord::RecordNotFound,
              with: :active_record_record_not_found
  rescue_from CanCan::AccessDenied, with: :cancan_access_denied

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

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_path
  end

  def load_cart
    session[:cart] ||= {}
  end

  def load_info_receiver
    session[:info_receiver] ||= {}
  end

  def active_record_record_not_found
    flash[:danger] = t "not_found_resource"
    redirect_to root_url
  end

  def cancan_access_denied
    flash[:danger] = t "shared.invalid_permision"
    redirect_to root_url
  end
end
