class CreateKepplerTravelTours < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_tours do |t|
      t.jsonb :title
      t.jsonb :description
      t.jsonb :task
      t.jsonb :files
      t.float :price_adults
      t.float :price_kids
      t.boolean :status
      t.integer :position
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :keppler_travel_tours, :deleted_at
  end
end
