module App
  module Dashboard
    module Drivers

      class TransfersController < DashboardController

        def drivers
        end

        def update_order
          @order = KepplerTravel::Order.find(params[:order_id])
          @order.update(status: 'complete')
          if params[:admin] == 'true'
            redirect_to admin_travel_reservation_path(@order.reservation, model_name: 'vehicle')
          else
            redirect_to drivers_transfers_path('es', 'usd'), notice: 'success'
          end
        end

        private

        def user_params
        end

      end

    end
  end
end
