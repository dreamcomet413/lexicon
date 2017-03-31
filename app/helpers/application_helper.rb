module ApplicationHelper
  
  def order_status(o)
    if o.success?
      "SUCCESS"
    elsif o.waiting_approval?
      "PENDING FOR APPROVAL"
    end
  end
end
