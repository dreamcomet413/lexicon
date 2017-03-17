class UserLevel < ApplicationRecord
  
  has_many :users
  validates :min_quantity, :level, presence: true
  validates_numericality_of :min_quantity, greater_than_or_equal_to: 1, only_integer: true
  validates_numericality_of :level
end
