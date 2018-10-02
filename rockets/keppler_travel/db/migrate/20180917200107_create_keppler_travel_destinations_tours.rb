class CreateKepplerTravelDestinationsTours < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_destinations_tours do |t|
      t.belongs_to :destination#, index: {name: 'destination_id'}
      t.belongs_to :tour#, index: {name: 'tour_id'}
      t.datetime :deleted_at
    end
  end
end
