class CreateKepplerTravelRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_rooms do |t|
      t.jsonb :title
      t.jsonb :price
      t.belongs_to :lodgment, index: {name: 'lodgment_id'}
      t.timestamps
    end
  end
end
