module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_search, only: [:index, :vehicles, :tours, :reservations]
    before_action :set_params_widget, only: [:vehicles, :tours]
    before_action :set_lang_currency
    before_action :delete_session, except: [:checkout, :create_reservation_transfer, :session_reservation_transfer, :create_reservation_tour, :session_reservation_tour]

    def set_locale_lang
      @locale = request.protocol + request.host_with_port + '/es'
    end

    def index
    end

    def vehicles
      @results = KepplerTravel::Vehicle.ransack(seat_gteq: @seats).result
    end

    def tours
      @results = KepplerTravel::Tour.find(params[:tour_id])
    end

    private

    def set_search
      @destinations = KepplerTravel::Destination.all
      @q = KepplerTravel::Vehicle.ransack(params[:q])
    end

    def set_params_widget
      @origin_location       = params[:origin_hidden]
      @origin_name           = params[:origin_vehicle]
      @arrival_location      = params[:arrival_hidden]
      @arrival_name          = params[:arrival_vehicle]
      @flight_origin_picker  = params[:flight_origin_picker]
      @flight_arrival_picker = params[:flight_arrival_picker]
      @round_trip            = params[:round_trip]
      @adults                = params[:quantity_adults]
      @kids                  = params[:quantity_kids]
      @seats                 = @adults.to_i + @kids.to_i
      @flight_origin_tour_picker  = params[:flight_origin_tour_picker]
    end

    def set_lang_currency
      @currency = params[:currency]
      @lang     = params[:locale]
    end

    def delete_session
      session.delete(:reservation)
      session.delete(:user)
      session.delete(:invoice)
      session.delete(:travellers)
      session.delete(:reservationable)
    end

  end
end
