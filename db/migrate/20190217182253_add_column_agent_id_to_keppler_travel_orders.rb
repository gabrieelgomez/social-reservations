class AddColumnAgentIdToKepplerTravelOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_travel_orders, :agent_id, :integer, index: true
  end
end
