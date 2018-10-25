class AddDestinationIdToKepplerTravelDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_drivers, :destination_id, :integer
  end
end
