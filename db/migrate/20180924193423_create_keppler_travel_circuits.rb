class CreateKepplerTravelCircuits < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_circuits do |t|
      t.jsonb :title
      t.integer :quantity_days
      t.jsonb :description
      t.jsonb :include
      t.jsonb :exclude
      t.jsonb :itinerary
      t.boolean :status, default: true
      t.jsonb :files
      t.integer :position
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :keppler_travel_circuits, :deleted_at
  end
end
