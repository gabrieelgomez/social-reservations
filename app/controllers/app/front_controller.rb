module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_search, only: [:index, :reservations]
    before_action :set_transfer, only: :reservations

    def set_locale
      @locale = request.protocol + request.host_with_port + '/es'
    end

    def index
    end

    def transfers
      @origin_location  = params[:origin_hidden]
      @origin_name      = params[:origin_transfer]
      @arrival_location = params[:arrival_hidden]
      @arrival_name     = params[:arrival_transfer]
      @round_trip = params[:round_trip]
      @adults = params[:quantity_adults]
      @kids   = params[:quantity_kids]
      @seats = @adults.to_i + @kids.to_i
      @results = KepplerTravel::Transfer.ransack(seat_gteq: @seats).result
    end

    def reservations
      @reservation = KepplerTravel::Reservation.new
    end

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
