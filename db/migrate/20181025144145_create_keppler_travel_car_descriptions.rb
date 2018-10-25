class CreateKepplerTravelCarDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_car_descriptions do |t|
      t.string :license
      t.string :color
      t.belongs_to :driver, index: true
      t.belongs_to :vehicle, index: true
      t.boolean :status
      t.timestamps
    end
  end
end
