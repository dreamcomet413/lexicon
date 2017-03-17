class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_min_qty_level
  
  def new
    @order = current_user.orders.build
    Product.all.each {|pr| @order.order_items.build(product: pr)}
  end

  def create
    @order = current_user.orders.build order_params
    sanitize_order
    if @order.save
      redirect_to "/pages/order_success"
    else
      render :new
    end
  end
  
  private
  def order_params
    params.require(:order).permit(order_items_attributes: [:product_id, :quantity, :min_qty_level])
  end
  
  def set_min_qty_level
    min_qty_level
  end
  
  def min_qty_level
    @min_qty_level ||= current_user.min_quantity
    @min_qty_level
  end
  
  def sanitize_order
    @order.order_items.each do |item| 
      item.min_qty_level = min_qty_level
      if item.quantity.blank?
        item.quantity = min_qty_level
      end
    end
  end
end
