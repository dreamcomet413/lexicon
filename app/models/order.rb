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
  
  enum status: {success: 0, waiting_approval: 1, rejected: 2}
  
  validates :user, presence: true
  accepts_nested_attributes_for :order_items, :reject_if => lambda{ |a| ((a["quantity"] == "0") || (a["quantity"] == 0)) }
  
  # admin uses this bit
  attr_accessor :reject_order
  
  validate :require_atleast_one_order_item
  validate :check_inventory_levels_on_update
  
  # before_create :update_total  
  # before_save :validate_present_of_reason_on_rejection, only: :update
  
  before_create :set_status
  before_update :on_reject_change_status
  after_create  :notify_through_email
  after_update  :adjust_inventory_levels_on_approval
  after_update  :notify_through_email_on_status_change
    
  private
  
  def check_inventory_levels_on_update
    if !new_record?
      order_items.includes(:product).each do |item|
        if item.quantity > item.product.quantity_available
          errors.add(:base, "Resource: #{product.name} inventory is insufficient.")
        end
      end
    end
  end
  
  def adjust_inventory_levels_on_approval
    if changes["status"].present? && (changes["status"].last == "success")
      order_items.each do |item|
        product = item.product
        product.with_lock do
          product.quantity_available -= item.quantity
          product.save!
        end
      end
    end
  end
  
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
  
  def set_status
    if order_items.any?(&:high_quantity?)
      self.status = "waiting_approval"
    end
  end
  
  def notify_through_email_on_status_change
    if changes["status"].present?
      notify_through_email
    end
  end
  
  def notify_through_email
    OrderMailer.order_confirmation(self).deliver_now
  end
  
  # active admin filter
  def self.with_product(product_id)
    joins(:order_items).where(order_items: {product_id: product_id} ).where.not(order_items: {quantity: 0})
  end
    
end
