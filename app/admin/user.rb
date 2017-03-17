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

filter :email

index do
  selectable_column
  id_column
  column :email
  column :level
  column :created_at
  column :updated_at
  column :last_sign_in_at
  column :sign_in_count
  actions
end

permit_params :email, :password, :password_confirmation, :user_level_id

form do |f|
  f.inputs "User Details" do
    f.input :email
    f.input :user_level_id, as: :select, collection: UserLevel.all.collect {|l| [l.level, l.id]}
    if resource.new_record?
      f.input :password
      f.input :password_confirmation
    end  
  end
  f.actions
end


end
