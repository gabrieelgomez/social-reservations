class CreateKepplerTravelDestinationsTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_destinations_transfers do |t|
      t.belongs_to :destination, index: {name: 'destination_id'}
      t.belongs_to :transfer, index: {name: 'transfer_id'}
    end
  end
end
