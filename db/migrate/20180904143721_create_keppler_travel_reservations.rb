class CreateKepplerTravelReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_reservations do |t|
      # Fields by vehicles/transfer
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
      # End fields -- normalizar
      t.text   :description
      t.belongs_to :user, foreign_key: true
      t.integer :reservationable_id, index: {name: 'reservationable_id'}
      t.string :reservationable_type, index: {name: 'reservationable_type'}
      # t.references :reservationable, polymorphic: true, index: true
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_travel_reservations, :deleted_at
    # add_index :reservations, [:reservationable_id, :reservationable_type]
  end
end
