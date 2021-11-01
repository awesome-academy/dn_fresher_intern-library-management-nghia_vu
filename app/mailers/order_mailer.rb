class OrderMailer < ApplicationMailer
  def order_uccess email, name
    @user_name = name
    mail to: email,
    subject: "Order success"
  end
end
