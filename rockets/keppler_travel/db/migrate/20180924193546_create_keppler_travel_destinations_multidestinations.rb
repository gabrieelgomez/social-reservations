class CreateKepplerTravelDestinationsMultidestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_destinations_multidestinations do |t|
      t.belongs_to :destination, index: {name: 'destination_multidestination_id'}
      t.belongs_to :multidestination, index: {name: 'multidestination_id'}
    end
  end
end
