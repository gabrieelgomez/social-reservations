class AddSubtitleToKepplerTravelCircuits < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_circuits, :subtitle, :jsonb
    add_column :keppler_travel_multidestinations, :subtitle, :jsonb
  end
end
