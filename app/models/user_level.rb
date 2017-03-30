class UserLevel < ApplicationRecord
  
  has_many :users
  has_many :orders, through: :users
  has_many :quantity_levels
  
  validates :level, presence: true
end
