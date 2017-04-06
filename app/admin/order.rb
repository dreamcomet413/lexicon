ActiveAdmin.register Order do
  
  scope :success, :default => true
  scope :waiting_approval, default: true
  scope :rejected
  
  filter :id
  filter :user
  filter :user_level
  filter :by_product_in,
    :as => :select,
    :label => 'contaiing product',
    :collection => proc { Product.order(:name) }
  
  
  actions :all, :except => [:destroy, :new]
  
  controller do
    def update
      update! {admin_orders_path(scope: 'waiting_approval')}
    end
  end
  
  index do
    selectable_column
    id_column
    column :user
    column "Products" do |order|
      link_to("view products", admin_order_order_items_path(order))
    end
    column :created_at
    if params[:scope].present? && (params[:scope] != "success")
      column "Controls" do |o|
        accept_link = link_to("Accept", change_status_admin_order_path(o), data: {confirm: "Are you sure?"})
        reject_link = link_to("Reject", edit_admin_order_path(o))
        if o.waiting_approval?
          accept_link + " || " + reject_link
        elsif o.rejected?
          accept_link
        end
      end
    end
  end
  
  member_action :change_status, method: :get do
    resource.success!
    msg = "Order##{resource.id}"
    flash["notice"] = "#{msg} status has been updated !"
    redirect_to(:back)
  end
  
  
  permit_params :reason_for_rejection, :reject_order

  form do |f|
    f.inputs "Order Rejection Details" do
      f.input :reason_for_rejection, as: :text, input_html: {required: true, value: "Sorry your order has been rejected for the following reason:"}
      f.input :reject_order, input_html: {value: '1', required: true}, as: :hidden
    end
    f.actions
  end
  
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
