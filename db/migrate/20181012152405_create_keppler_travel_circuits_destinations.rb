class CreateKepplerTravelCircuitsDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_circuits_destinations do |t|
      t.belongs_to :circuit#, index: {name: 'circuit_id'}
      t.belongs_to :destination#, index: {name: 'destination_id'}
    end
  end
end
