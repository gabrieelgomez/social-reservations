class CreateKepplerTravelReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_reservations do |t|
      t.string :origin
      t.string :arrival
      t.string :origin_location
      t.string :arrival_location
      t.string :flight_origin
      t.string :flight_arrival
      t.integer :quantity_adults
      t.integer :quantity_kids
      t.integer :quantity_kit
      t.string :round_trip
      t.string :airline_origin
      t.string :airline_arrival
      t.string :flight_number_origin
      t.string :flight_number_arrival
      t.text :invoice_address
      t.text   :description
      t.references :user, foreign_key: true
      t.belongs_to :vehicle#, index: {name: 'vehicle_id'}
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_travel_reservations, :deleted_at
  end
end
