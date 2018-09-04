module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_search, only: :index
    before_action :set_transfer, only: :reservations

    def set_locale
      @locale = request.protocol + request.host_with_port + '/es'
    end

    def index
    end

    def transfers
      # destinations = params[:q][:destinations_id_in]
      # adults = params[:q][:quantity_adults_lteq]
      # kids = params[:q][:quantity_kids_lteq]
      # @results = KepplerTravel::Transfer.ransack(destinations_id_in: destinations).result
      #                                   .ransack(quantity_adults_gteq: adults).result
      #                                   .ransack(quantity_kids_gteq: kids).result
      @results = KepplerTravel::Transfer.all
      @origin_location  = params[:origin_hidden]
      @origin_name      = params[:origin_transfer]
      @arrival_location = params[:arrival_hidden]
      @arrival_name     = params[:arrival_transfer]
    end

    def reservations
      @reservation = KepplerTravel::Reservation.new
    end

    # def show_transfers
    #   @transfer = KepplerTravel::Transfer.find params[:id]
    #   @destacados = KepplerTravel::Transfer.all.sample(10)
    # end

    # def login
    # end

    private

    def set_search
      @destinations = KepplerTravel::Destination.all
      @q = KepplerTravel::Transfer.ransack(params[:q])
    end

    def set_transfer
      @transfer = KepplerTravel::Transfer.find params[:transfer_id]
    end

    def set_locale
      @currency = params[:currency]
      @lang     = params[:locale]
    end
  end
end
