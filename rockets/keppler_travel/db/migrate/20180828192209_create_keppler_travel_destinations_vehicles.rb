class CreateKepplerTravelDestinationsVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_destinations_vehicles do |t|
      t.belongs_to :destination, index: {name: 'destination_id'}
      t.belongs_to :vehicle, index: {name: 'vehicle_id'}
    end
  end
end
