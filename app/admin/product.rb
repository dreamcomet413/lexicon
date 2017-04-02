ActiveAdmin.register Product do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  actions :all
  
  filter :name
  
  permit_params :name, :description, :image, quantity_levels_attributes: [:product_id, :user_level_id, :min_quantity, :max_quantity, :id]
  
  controller do
    def new 
      super do |format|
        UserLevel.all.each do |ul|
          resource.quantity_levels.build(user_level_id: ul.id)
        end
      end
    end
  end
  
  index do
    id_column
    column :name
    column "User Levels" do |product|
      columns do
        column { "<strong><u>Level</u></strong>".html_safe }
        column {"<strong><u>Quantity Ordered</u></strong>".html_safe }
      end
      product.quantity_levels.includes(:user_level).each do |ql|
        columns do
          column {|c| ql.user_level.level}
          column {|c| 
            prod_count = ql.user_level.product_order_count(product)
            link_to(prod_count, admin_orders_path('q[by_product_in]': product.id, 'q[user_level_id_eq]': ql.user_level_id))
          }
        end
      end
      ""
    end
  end
  
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
      f.input :description
      f.input :image, :as => :file
      f.inputs do
        f.has_many :quantity_levels, allow_destroy: false, new_record: false do |a|
          level_name = "Quatity level for User level: #{UserLevel.where(id: a.object.user_level_id).first.try(:level)}"
          inputs level_name do
            a.input :min_quantity
            a.input :max_quantity
            a.input :user_level_id, as: :hidden
          end
        end
      end
    end
    f.actions
  end
  

end
