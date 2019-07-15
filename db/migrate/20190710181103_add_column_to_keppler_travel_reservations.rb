class AddColumnToKepplerTravelReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_reservations, :reservation_mobile, :boolean
  end
end
