class AddColumTravellersFilesToKepplerTravelReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_reservations, :file, :string, default: ''
  end
end
