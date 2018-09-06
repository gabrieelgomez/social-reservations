module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_search, only: [:index, :vehicles, :reservations]
    before_action :set_vehicle, only: :reservations

    def set_locale
      @locale = request.protocol + request.host_with_port + '/es'
    end

    def index
    end

    def vehicles
      @origin_location  = params[:origin_hidden]
      @origin_name      = params[:origin_vehicle]
      @arrival_location = params[:arrival_hidden]
      @arrival_name     = params[:arrival_vehicle]
      @flight_origin_picker  = params[:flight_origin_picker]
      @flight_arrival_picker = params[:flight_arrival_picker]
      @round_trip = params[:round_trip]
      @adults = params[:quantity_adults]
      @kids   = params[:quantity_kids]
      @seats = @adults.to_i + @kids.to_i
      @results = KepplerTravel::Vehicle.ransack(seat_gteq: @seats).result
    end

    def reservations
      @reservation = KepplerTravel::Reservation.new
      @adults = params[:adults]
      @kids   = params[:kids]
      @seats = @adults.to_i + @kids.to_i
    end

    private

    def set_search
      @destinations = KepplerTravel::Destination.all
      @q = KepplerTravel::Vehicle.ransack(params[:q])
    end

    def set_vehicle
      @vehicle = KepplerTravel::Vehicle.find params[:vehicle_id]
    end

    def set_locale
      @currency = params[:currency]
      @lang     = params[:locale]
    end
  end
end
