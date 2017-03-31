class Order < ApplicationRecord

  has_many :order_items
  belongs_to :user
  belongs_to :user_level
  
  enum status: {success: 0, waiting_approval: 1}
  
  validates :user, presence: true
  accepts_nested_attributes_for :order_items
  
  before_create :update_total
  after_create :set_status
  after_create :notify_through_email
  
  private
  
  def calculate_total
    order_items.sum { |oi| oi.quantity * oi.unit_price  }
  end

  def update_total
    self.total = calculate_total
  end
  
  def set_status
    order_items.any?(&:high_quantity?) ? self.waiting_approval! : self.success!
  end
  
  def notify_through_email
    OrderMailer.order_confirmation(self).deliver_now
  end
    
end
