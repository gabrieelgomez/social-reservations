class CreateKepplerTravelRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_rooms do |t|
      t.string :type_room
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
