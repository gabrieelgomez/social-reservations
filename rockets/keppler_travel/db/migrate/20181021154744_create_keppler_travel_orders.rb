class CreateKepplerTravelOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_orders do |t|
      t.string :status
      t.string :details
      t.belongs_to :driver, index: true
      t.belongs_to :reservation, index: true

      t.timestamps
    end
  end
end
