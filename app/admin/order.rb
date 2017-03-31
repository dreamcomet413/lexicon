ActiveAdmin.register Order do
  
  belongs_to :user_level, optional: true
  
  scope :success, :default => true
  scope :waiting_approval, default: true
  
  filter :id
  
  actions :all, :except => [:destroy]
  
  index do
    selectable_column
    id_column
    column :user
    column "Products count" do |order|
      link_to("#{order.order_items.sum(&:quantity)}", admin_order_order_items_path(order))
    end
    column :created_at
    actions
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
