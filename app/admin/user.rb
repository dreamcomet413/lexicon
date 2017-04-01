ActiveAdmin.register User do
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

filter :email

index do
  selectable_column
  id_column
  column :email
  column :level
  column "Orders Placed" do |u|
    link_to(u.orders.count, admin_orders_path(user_id: u.id))
  end
  column :last_sign_in_at
  actions
end

permit_params :email, :password, :password_confirmation, :user_level_id, :first_name, :last_name, :street_address, :city, :state,
:zip_code, :telephone, :sales_force, :region, :region_id, :territory_alignment, :territory_id, :employee_id

form do |f|
  f.inputs "User Details" do
    f.input :first_name
    f.input :last_name
    f.input :email
    f.input :user_level_id, as: :select, collection: UserLevel.all.collect {|l| [l.level, l.id]}
    if resource.new_record?
      f.input :password
      f.input :password_confirmation
    end
    f.input :street_address
    f.input :city
    f.input :state, as: :select, collection: us_states
    f.input :zip_code, input_html: {type: :number}
    f.input :telephone, input_html: {type: :tel}
    f.input :sales_force
    f.input :region, as: :select, collection: regions
    f.input :region_id, label: "Region ID"
    f.input :territory_alignment
    f.input :territory_id, label: "Territory ID"
    f.input :employee_id, label: "Employee ID"
  end
  f.actions
end


end
