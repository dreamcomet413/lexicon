class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  # validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 1 }
  validate :product_present
  validate :check_min_quantity_critera, on: :create

  before_save :finalize
  
  attr_accessor :min_qty_level

  def unit_price
    if persisted?
      self.unit_price
    else
      product.price
    end
  end

  def total_price
    unit_price * quantity
  end


  private
  
  def check_min_quantity_critera
    if quantity < min_qty_level
      self.errors.add(:quantity, "should be minimum #{min_qty_level}.")
    end
  end
  
  def product_present
    if product.nil?
      errors.add(:product, "is not valid or is not active.")
    end
  end

  def finalize
    self.unit_price = unit_price
    self.total_price = quantity * self.unit_price
  end
end