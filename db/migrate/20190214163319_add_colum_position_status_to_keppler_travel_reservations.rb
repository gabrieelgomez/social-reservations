class AddColumPositionStatusToKepplerTravelReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_reservations, :position_status, :integer, default: 1
  end
end
