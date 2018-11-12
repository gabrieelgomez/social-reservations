class CreateKepplerTravelLicenses < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_licenses do |t|
      t.string :matricula
      t.string :color
      t.belongs_to :car_description, index: true
      t.timestamps
    end
  end
end
