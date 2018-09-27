class CreateKepplerTravelLodgments < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_lodgments do |t|
      t.jsonb :title
      t.string :type_rooms
      t.integer :position
      t.datetime :deleted_at
      t.belongs_to :destination#, index: {name: 'destination_id'}
      t.timestamps
    end
    add_index :keppler_travel_lodgments, :deleted_at
  end
end
