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
        destinations = params[:q][:destinations_id_in]
        adults = params[:q][:quantity_adults_lteq]
        kids = params[:q][:quantity_kids_lteq]
        @results = KepplerTravel::Transfer.ransack(destinations_id_in: destinations).result
                               .ransack(quantity_adults_gteq: adults).result
                               .ransack(quantity_kids_gteq: kids).result
      end
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
