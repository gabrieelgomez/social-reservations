class CreateKepplerTravelTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_transfers do |t|
      t.string :cover
      t.jsonb :title
      t.jsonb :description
      t.jsonb :includes
      t.jsonb :conditions
      t.jsonb :files
      t.jsonb :kit
      t.integer :quantity_adults
      t.integer :quantity_kids
      t.datetime :date
      t.datetime :time
      t.jsonb :price
      t.integer :position
      # t.string :slug
      t.datetime :deleted_at

      t.timestamps
    end
    # add_index :keppler_travel_transfers, :slug, unique: true
    add_index :keppler_travel_transfers, :deleted_at
  end
end
