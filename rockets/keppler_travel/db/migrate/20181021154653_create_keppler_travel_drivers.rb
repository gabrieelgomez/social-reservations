class CreateKepplerTravelDrivers < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_drivers do |t|
      t.string :timetrack
      t.integer :position
      t.datetime :deleted_at
      t.belongs_to :user, index: true

      t.timestamps
    end
    add_index :keppler_travel_drivers, :deleted_at
  end
end
