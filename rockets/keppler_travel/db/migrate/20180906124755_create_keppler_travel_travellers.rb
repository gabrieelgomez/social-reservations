class CreateKepplerTravelTravellers < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_travellers do |t|
      t.string :name
      t.string :dni
      t.belongs_to :reservation, index: {name: 'reservation_id'}
      t.timestamps
    end
  end
end
