class CreateKepplerTravelDestinationsTours < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_destinations_tours do |t|
      t.belongs_to :destination
      t.belongs_to :tour
      t.datetime :deleted_at
    end
  end
end
