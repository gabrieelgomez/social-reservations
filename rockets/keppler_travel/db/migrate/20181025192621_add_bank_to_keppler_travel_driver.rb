class AddBankToKepplerTravelDriver < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_drivers, :bank, :string
    add_column :keppler_travel_drivers, :account_type, :string
    add_column :keppler_travel_drivers, :account_number, :text
  end
end
