class CreateKepplerTravelVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_vehicles do |t|
      t.string :cover
      t.jsonb :title
      t.jsonb :description
      t.jsonb :includes
      t.jsonb :conditions
      t.jsonb :files
      t.jsonb :kit
      t.integer :seat
      t.datetime :date
      t.datetime :time
      t.jsonb :inner_price
      t.jsonb :outer_price
      t.integer :position
      # t.string :slug
      t.datetime :deleted_at

      t.timestamps
    end
    # add_index :keppler_travel_vehicles, :slug, unique: true
    add_index :keppler_travel_vehicles, :deleted_at
  end
end
