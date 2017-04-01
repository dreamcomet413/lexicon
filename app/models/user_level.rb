class UserLevel < ApplicationRecord
  
  has_many :users
  has_many :orders
  has_many :quantity_levels
  
  validates :level, presence: true, uniqueness: true
end
