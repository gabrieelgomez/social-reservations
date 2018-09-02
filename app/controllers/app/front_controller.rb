module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_search

    def set_locale
      @locale = request.protocol + request.host_with_port + '/es'
    end

    def index
    end

    def transfers
      unless @q.nil?
        destinations =  nil
        adults =  nil
        kids = nil
        @results = KepplerTravel::Transfer.ransack(destinations_id_in: destinations).result
                               .ransack(quantity_adults_gteq: adults).result
                               .ransack(quantity_kids_gteq: kids).result
      end
    end

    def show_transfers
      @transfer = KepplerTravel::Transfer.find params[:id]
      @destacados = KepplerTravel::Transfer.all.sample(10)
    end

    def reservation_transfers

    end

    def login
    end

    private

    def set_search
      @destinations = KepplerTravel::Destination.all
      @q = KepplerTravel::Transfer.ransack(params[:q])
    end

    def set_locale
      @currency = params[:currency]
      @lang     = params[:locale]
    end
  end
end
