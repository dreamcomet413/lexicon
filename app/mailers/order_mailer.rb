class OrderMailer < ApplicationMailer
  
  def order_confirmation(order)
    @order = order
    mail(to: "admin@lexicon.com", subject: 'Your Order has been placed successfully')
  end
end
