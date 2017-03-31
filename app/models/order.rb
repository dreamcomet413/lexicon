class Order < ApplicationRecord

  has_many :order_items
  belongs_to :user
  belongs_to :user_level
  
  enum status: {success: 0, waiting_approval: 1, rejected: 2}
  
  validates :user, presence: true
  accepts_nested_attributes_for :order_items
  
  attr_accessor :reject_order
  
  before_create :update_total
  after_create :set_status
  after_create :notify_through_email
  
  before_update :notify_on_order_rejection
  before_save :validate_present_of_reason_on_rejection, only: :update
  
  private
  
  def validate_present_of_reason_on_rejection
    if reject_order.present?
      if reason_for_rejection.blank?
        errors.add(:reason_for_rejection, "must be present.")
      end
    end
  end
  
  def notify_on_order_rejection
    if reason_for_rejection.present? && reject_order.present?
      self.status = "rejected"
    end
  end
  
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
