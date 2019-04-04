class RenameColumnFileToKepplerTravelReservations < ActiveRecord::Migration[5.2]
  def change
    rename_column :keppler_travel_reservations, :file, :travellers_doc
  end
end
