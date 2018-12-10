class AddHourToKepplerTravelReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_reservations, :hour_origin, :string
    add_column :keppler_travel_reservations, :hour_arrival, :string
  end
end
