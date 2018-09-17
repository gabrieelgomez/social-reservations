module App
  # DashboardsController
  class DashboardController < AppController
    layout 'layouts/templates/application'
    before_action :set_user, only: %i[users]
    before_action :authenticate_user!
    before_action :set_lang_currency

    def transfer_orders
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
