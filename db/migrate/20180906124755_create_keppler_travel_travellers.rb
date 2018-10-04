class CreateKepplerTravelTravellers < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_travellers do |t|
      t.string :name
      t.string :dni
      t.datetime :deleted_at
      t.belongs_to :reservation, index: {name: 'reservation_id'}
      t.timestamps
    end
    add_index :keppler_travel_travellers, :deleted_at
  end
end
