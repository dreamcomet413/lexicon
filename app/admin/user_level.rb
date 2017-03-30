ActiveAdmin.register UserLevel do
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

actions :all, :except => [:destroy]

index do
  selectable_column
  column :level
  actions
  column "Orders" do |ul|
    link_to("view", admin_user_level_orders_path(ul))
  end  
end

permit_params :level

end
