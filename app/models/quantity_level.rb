class QuantityLevel < ApplicationRecord
  
  validates :min_quantity, presence: true
  validates_numericality_of :min_quantity, greater_than_or_equal_to: 1, only_integer: true

  validates :max_quantity, presence: true
  validates_numericality_of :max_quantity, greater_than_or_equal_to: 1, only_integer: true
  
  validates_numericality_of :min_quantity, :max_quantity
  
  validate :max_greater_than_min
  
  belongs_to :user_level
  belongs_to :product
  
  private
  def max_greater_than_min
    if max_quantity.present? && min_quantity.present?
      if max_quantity <= min_quantity
        errors.add(:max_quantity, "should be greater than minimum quantity")
      end
    end
  end
  
end
