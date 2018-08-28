class CreateKepplerTravelTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_transfers do |t|
      t.string :cover
      t.jsonb :title
      t.jsonb :description
      t.string :quantity_person
      t.datetime :date
      t.datetime :time
      t.jsonb :price
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_travel_transfers, :deleted_at
  end
end
