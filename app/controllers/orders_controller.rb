class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @order = current_user.orders.build
    Product.all.each {|pr| @order.order_items.build(product: pr)}
  end

  def create
    @order = current_user.orders.build order_params
    if @order.save
      redirect_to "/pages/order_success"
    else
      render :new
    end
  end
  
  private
  def order_params
    params.require(:order).permit(order_items_attributes: [:product_id, :quantity])
  end
end
