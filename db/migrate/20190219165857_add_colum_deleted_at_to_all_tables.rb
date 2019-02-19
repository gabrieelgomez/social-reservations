class AddColumDeletedAtToAllTables < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_car_descriptions, :deleted_at, :datetime
    add_column :keppler_travel_licenses,         :deleted_at, :datetime
    add_column :keppler_travel_orders,           :deleted_at, :datetime
  end
end
