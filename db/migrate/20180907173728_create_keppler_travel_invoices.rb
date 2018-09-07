class CreateKepplerTravelInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_invoices do |t|
      t.string :token
      t.belongs_to :reservation, index: true
      t.timestamps
    end
  end
end
