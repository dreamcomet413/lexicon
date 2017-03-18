ActiveAdmin.register Product do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  actions :all, :except => [:destroy]
  
  permit_params :name, :price, :description, :image
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :price
      f.input :description
      f.input :image, :as => :file
    end
    f.actions
  end
  

end
