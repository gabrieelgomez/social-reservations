module App
  module Dashboard
    class DashboardController < FrontController
      # layout 'app/front/dashboard/transfer_orders'
      # layout 'app/front/dashboard/layouts/application'
      before_action :authenticate_user!
      before_action :set_user, only: %i[users]
      before_action :set_lang_currency

      def index
      end

      def template
      end

      def template_user
      end

      def template_order
      end
      
      def orders
        redirect_to drivers_transfers_path('es', 'usd') if current_user.has_role? :driver
      end

      def users
      end

      def drivers
        @orders = current_user.driver.orders
      end

      private

      def set_user
        @user = current_user
      end

      def set_lang_currency
        @currency = params[:currency]
        @lang     = params[:locale]
      end

    end
  end
end
