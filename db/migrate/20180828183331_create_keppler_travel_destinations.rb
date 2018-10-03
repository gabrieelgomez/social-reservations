class CreateKepplerTravelDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_destinations do |t|
      t.string :title
      t.float :latitude
      t.float :longitude
      t.jsonb :custom_title
      t.string :cover
      t.jsonb :description
      t.integer :position
      t.boolean :status
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :keppler_travel_destinations, :deleted_at
  end
end
