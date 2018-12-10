class AddNightToKepplerTravelCircuitableRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_circuitable_rooms, :night_price_usd, :float, default: 0
    add_column :keppler_travel_circuitable_rooms, :night_price_cop, :float, default: 0
  end
end
