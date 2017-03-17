class OrderMailer < ApplicationMailer
  
  def order_confirmation(order)
    @order = order
    mail(to: order.user.email, subject: 'Your Order has been placed successfully')
  end
end
