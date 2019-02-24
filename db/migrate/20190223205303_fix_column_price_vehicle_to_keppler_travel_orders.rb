class FixColumnPriceVehicleToKepplerTravelOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :keppler_travel_orders, :price_vehicle, :price_reservationable
  end
end
