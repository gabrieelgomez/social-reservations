module App
  # DashboardsController
  class DashboardController < AppController
    layout 'layouts/templates/application'
    before_action :set_lang_currency

    def transfer_orders
    end

    private

    def set_lang_currency
      @currency = params[:currency]
      @lang     = params[:locale]
    end

  end
end
