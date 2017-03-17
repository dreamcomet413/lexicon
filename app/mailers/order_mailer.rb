class OrderMailer < ApplicationMailer
  
  def order_confirmation(order)
    @order = order
    mail(to: "piyushshivam@gmail.com", subject: 'Your Order has been placed successfully')
  end
end
