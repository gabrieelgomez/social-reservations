class CreateKepplerTravelCircuitableRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_circuitable_rooms do |t|
      t.float :price_cop
      t.float :price_usd
      t.boolean :status
      t.belongs_to :room, index: true
      t.belongs_to :circuitable, index: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
