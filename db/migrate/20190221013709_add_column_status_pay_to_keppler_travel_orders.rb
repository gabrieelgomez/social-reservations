class AddColumnStatusPayToKepplerTravelOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_orders, :status_pay, :string, default: 'pending'
    add_column :keppler_travel_orders, :url_payment, :string, default: ''

    add_column :keppler_travel_invoices, :status_pay, :string, default: 'pending'

    add_column :keppler_travel_reservations, :status_pay, :string, default: 'pending'
    add_column :keppler_travel_reservations, :position_status_pay, :integer, default: 1
    add_column :keppler_travel_reservations, :url_payment, :string, default: ''
  end
end
