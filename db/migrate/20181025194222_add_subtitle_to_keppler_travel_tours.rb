class AddSubtitleToKepplerTravelTours < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_tours, :subtitle, :jsonb
  end
end
