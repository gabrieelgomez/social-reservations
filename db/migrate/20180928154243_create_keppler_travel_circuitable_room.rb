class CreateKepplerTravelCircuitableRoom < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_circuitable_rooms do |t|
      t.jsonb :price
      t.boolean :status
      t.belongs_to :room, index: true
      t.belongs_to :circuitable, index: true
      t.datetime :deleted_at
    end
  end
end
