class CreateKepplerTravelLodgmentsRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_lodgments_rooms do |t|
      t.belongs_to :lodgment#, index: {name: 'destination_id'}
      t.belongs_to :room#, index: {name: 'tour_id'}
      t.datetime :deleted_at
    end
  end
end
