class OrdersController < ApplicationController
  http_basic_authenticate_with name: "safe", password: "qwerty!@"
  
  layout false
  
  before_action :authenticate_user!
  
  def new
    @order = current_user.orders.build
    logger.info Product.all.inspect
    Product.all.includes(:quantity_levels).each do |pr| 
      qty_level = pr.quantity_levels.find {|l| l.user_level_id == current_user.user_level_id}
      @order.order_items.build(product: pr, quantity: qty_level.min_quantity, min_qty_level: qty_level.min_quantity, max_qty_level: qty_level.max_quantity)
    end
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
    params.require(:order).permit(order_items_attributes: [:product_id, :quantity, :min_qty_level, :max_quantity_level])
  end
  
  def sanitize_order
    @order.order_items.each do |item| 
      qty_level = Product.where(id:item.product_id).first.quantity_levels.where(user_level_id: current_user.user_level_id).first
      item.min_qty_level = qty_level.min_quantity
      item.max_qty_level = qty_level.max_quantity
      if item.quantity.blank?
        item.quantity = qty_level.min_quantity
      end
    end
  end
end
