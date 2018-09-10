class CreateKepplerTravelInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_travel_invoices do |t|
      t.string :token
      t.string :amount
      t.string :currency
      t.string :status
      t.text :address
      t.belongs_to :reservation, index: true
      t.timestamps
    end
  end
end
