class AddEmailCorporativeToKepplerTravelDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_drivers, :email_corporative, :string, default: 'example@example.com'
  end
end
