class AddColumnOwnerToKepplerTravelAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_agencies, :owner, :string, default: ''
  end
end
