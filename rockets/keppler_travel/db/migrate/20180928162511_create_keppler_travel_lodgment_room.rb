class CreateKepplerTravelLodgmentsRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_lodgments_rooms do |t|
      t.belongs_to :lodgment
      t.belongs_to :room
      t.datetime :deleted_at
    end
  end
end
