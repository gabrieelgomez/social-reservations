class CreateKepplerTravelCircuitables < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_circuitables do |t|
      t.belongs_to :destination, index: true
      t.belongs_to :lodgment, index: true
      t.belongs_to :circuit, index: true
      t.boolean :status
      t.datetime :deleted_at
    end
  end
end
