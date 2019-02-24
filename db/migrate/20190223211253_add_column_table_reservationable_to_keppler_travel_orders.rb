class AddColumnTableReservationableToKepplerTravelOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_orders, :table_reservationable, :jsonb, default: {}
  end
end
