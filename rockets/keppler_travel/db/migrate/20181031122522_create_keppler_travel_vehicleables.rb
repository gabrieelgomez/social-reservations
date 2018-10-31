class CreateKepplerTravelVehicleables < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_vehicleables do |t|
      t.string :title
      t.boolean :status, default: false
      t.float :price_usd, default: 0
      t.float :price_cop, default: 0
      t.belongs_to :vehicle, index: true
      t.belongs_to :destination, index: true
      t.datetime   :deleted_at
    end
  end
end
