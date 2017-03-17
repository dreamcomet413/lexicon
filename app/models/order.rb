class Order < ApplicationRecord

  has_many :order_items
  belongs_to :user
  
  validates :user, presence: true
  before_save :update_total
  
  accepts_nested_attributes_for :order_items
  
  private
  
  def calculate_total
    order_items.sum { |oi| oi.quantity * oi.unit_price  }
  end

  def update_total
    self.total = calculate_total
  end
  
end
