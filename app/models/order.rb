class Order < ApplicationRecord

  has_many :order_items, dependent: :destroy
  belongs_to :user
  belongs_to :user_level
  
  ransacker :by_product,
    formatter: proc { |product_id|
      results = Order.with_product(product_id).map(&:id)
      results = results.present? ? results : nil
    } do |parent|
    parent.table[:id]
  end
  
  def self.with_product(product_id)
    joins(:order_items).where(order_items: {product_id: product_id} )
  end
  

  def self.has_pc(pc_id)
    self.joins(:products).where(products: {product_color_id: pc_id})
  end
  
  enum status: {success: 0, waiting_approval: 1, rejected: 2}
  
  validates :user, presence: true
  accepts_nested_attributes_for :order_items #, :reject_if => lambda{ |a| a[:quantity] == "0" }
  
  attr_accessor :reject_order
  
  # before_create :update_total
  
  before_update :on_reject_change_status
  # before_save :validate_present_of_reason_on_rejection, only: :update
  
  after_create :set_status_and_notify
  after_update :notify_through_email
  
  validate :require_atleast_one_order_item
  
  private
  def require_atleast_one_order_item
    errors.add(:base, "You must order atleast one product") if all_order_items_have_quantity_zero?
  end
  
  def all_order_items_have_quantity_zero?
    !order_items.collect(&:quantity).any? {|i| i > 0}
  end
      
  def validate_present_of_reason_on_rejection
    if reject_order.present?
      if reason_for_rejection.blank?
        errors.add(:reason_for_rejection, "must be present.")
      end
    end
  end
  
  def on_reject_change_status
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
  
  def set_status_and_notify
    if order_items.any?(&:high_quantity?)
      self.waiting_approval!
      notify_through_email
    else
      notify_through_email
    end
  end
  
  def notify_through_email_on_approval
    if previous_changes["status"].present? && (previous_changes["status"] == "waiting_approval")
      notify_through_email
    end
  end
  
  def notify_through_email
    OrderMailer.order_confirmation(self).deliver_now
  end
    
end
