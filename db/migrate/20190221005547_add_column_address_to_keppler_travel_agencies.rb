class AddColumnAddressToKepplerTravelAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_agencies, :address, :text, default: ''
    add_column :keppler_travel_agencies, :nit, :string, default: ''
    add_column :keppler_travel_agencies, :rnt, :string, default: ''
    add_column :keppler_travel_agencies, :country, :string, default: ''
  end
end
