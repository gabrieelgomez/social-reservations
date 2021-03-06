class CreateKepplerTravelTours < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_tours do |t|
      t.jsonb :title
      t.jsonb :description
      t.jsonb :task
      t.jsonb :files
      t.jsonb :price_adults
      t.jsonb :price_kids
      t.string :banner
      t.boolean :status, default: true
      t.integer :position
      t.boolean :featured
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :keppler_travel_tours, :deleted_at
  end
end
