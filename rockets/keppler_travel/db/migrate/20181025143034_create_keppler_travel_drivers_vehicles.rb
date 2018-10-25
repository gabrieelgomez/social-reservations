class CreateKepplerTravelDriversVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_drivers_vehicles do |t|
      t.belongs_to :driver, index: {name: 'driver_id'}
      t.belongs_to :vehicle, index: true#, index: {name: 'vehicle_id'}
      t.datetime :deleted_at
    end
  end
end
