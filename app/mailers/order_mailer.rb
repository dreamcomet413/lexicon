class OrderMailer < ApplicationMailer
  
  def order_confirmation(order)
    @order = order
    subject = "Order##{order.id} Status:#{order.status}"
    recipients = "piyushshivam@gmail.com, #{order.user.email}"
    
    mail(to: recipients, subject: subject)
  end
end
