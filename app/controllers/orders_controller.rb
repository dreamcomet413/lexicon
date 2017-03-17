class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @order = current_user.orders.build
    Product.all.each {|pr| @order.order_items.build(product: pr)}
  end

  def create
    @order = current_user.orders.build order_params
    @order.save
    render :new
  end
  
  private
  def order_params
    params.require(:order).permit(order_items_attributes: [:product_id, :quantity])
  end
end
