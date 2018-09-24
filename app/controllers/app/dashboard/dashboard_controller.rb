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

      def transfer_orders
      end

      def tour_orders
      end

      def users
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
