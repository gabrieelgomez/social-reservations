class AddColumnUserEmailToKepplerTravelOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_orders, :user_referer, :string
    add_column :keppler_travel_orders, :driver_referer, :integer
    add_column :keppler_travel_orders, :agency_referer, :integer
    add_column :keppler_travel_orders, :agent_referer, :integer
  end
end
