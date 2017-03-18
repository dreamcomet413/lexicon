ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do


    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      
      column do
        panel "User level - Orders" do
          table_for UserLevel.all do
            column("Level")   {|l| l.level }
            column("Min Qty"){|l| l.min_quantity }
            column("Orders Placed"){|l| link_to(l.orders.count, admin_user_level_orders_path(l)) }            
          end
        end
      end
      
      column do
        panel "Recent Orders" do
          table_for Order.order("id DESC").first(5) do
            column("Order#ID")   {|order| link_to("ID#{order.id}", admin_order_path(order)) }
            column("Order Total"){|order| number_to_currency(order.total) }
          end          
        end
      end
      
    end  
    
    columns do
      
      column do
        panel "Recent Users" do
          table_for User.order("id DESC").first(5) do
            column("Email")   {|user| link_to(user.email, admin_user_path(user)) }
            column("User Level"){|user| user.level }
            column("Order placed")   {|user| user.orders.count }
          end          
        end
      end
      
    end

  end # content
end
