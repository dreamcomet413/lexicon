class Product < ApplicationRecord
  
  has_many :order_items
  
  validates :name, :price, :description, presence: true
  validates_numericality_of :price, greater_than_or_equal_to: 0
end
