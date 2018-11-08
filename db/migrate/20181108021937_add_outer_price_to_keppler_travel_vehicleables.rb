class AddOuterPriceToKepplerTravelVehicleables < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_vehicleables, :price_outer_cop, :float, default: 0
    add_column :keppler_travel_vehicleables, :price_outer_usd, :float, default: 0
    rename_column :keppler_travel_vehicleables, :price_cop, :price_inner_cop
    rename_column :keppler_travel_vehicleables, :price_usd, :price_inner_usd
  end
end
