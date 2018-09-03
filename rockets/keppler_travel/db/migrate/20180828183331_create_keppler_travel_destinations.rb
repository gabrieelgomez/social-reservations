class CreateKepplerTravelDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_destinations do |t|
      t.string :title
      t.float :latitude
      t.float :longitude
      t.string :cover
      t.string :description
      t.integer :position
      t.string :slug
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_travel_destinations, :slug, unique: true
    add_index :keppler_travel_destinations, :deleted_at
  end
end
