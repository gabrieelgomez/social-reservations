class AddColumnAgencyIdToKepplerTravelOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_orders, :agency_id, :integer, index: true
    add_column :keppler_travel_orders, :comission, :float, default: 0
    add_column :keppler_travel_orders, :lending, :float, default: 0
    add_column :keppler_travel_orders, :price_comission, :float, default: 0
    add_column :keppler_travel_orders, :price_lending, :float, default: 0
    add_column :keppler_travel_orders, :price_total_agency, :float, default: 0
    add_column :keppler_travel_orders, :price_total_pax, :float, default: 0
    add_column :keppler_travel_orders, :price_vehicle, :float, default: 0
  end
end
