class User < ApplicationRecord
  extend Devise::Models
  
  has_many :orders
  belongs_to :user_level
  
  validates_associated :user_level
  validates :user_level_id, presence: true
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  before_create :assign_default_level
  
  delegate :level, to: :user_level
  
  private
  
  def assign_default_level
    if !user_level
      self.user_level = UserLevel.where('level = MIN(level)')
    end
  end
end
