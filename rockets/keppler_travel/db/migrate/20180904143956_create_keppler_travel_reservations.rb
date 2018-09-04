class CreateKepplerTravelReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_reservations do |t|
      t.string :origin
      t.string :arrival
      t.string :origin_location
      t.string :arrival_location
      t.bigint :flight_origin
      t.bigint :flight_arrival
      t.integer :quantity_adults
      t.integer :quantity_kids
      t.integer :quantity_kit
      t.boolean :roud_trip
      t.boolean :airport_origin
      t.string :airline
      t.string :flight_number
      t.references :user, foreign_key: true
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_travel_reservations, :deleted_at
  end
end
