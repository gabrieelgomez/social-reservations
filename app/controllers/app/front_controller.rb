module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_lang_currency
    before_action :set_search,        only: %i[index reservations tours vehicles]
    before_action :set_params_widget, only: %i[tours vehicles]
    before_action :delete_session,    except: %i[checkout create_reservation_transfer session_reservation_transfer create_reservation_tour session_reservation_tour]

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

    def circuits
    end

    def errors
    end

    private

    def set_search
      @destinations = KepplerTravel::Destination.all
      @q = KepplerTravel::Vehicle.ransack(params[:q])
    end

    def set_params_widget
      @origin_location       = params[:origin_location]
      @origin_name           = params[:origin_name]
      @arrival_location      = params[:arrival_location]
      @arrival_name          = params[:arrival_name]
      @flight_origin_picker  = params[:flight_origin_picker]
      @flight_arrival_picker = params[:flight_arrival_picker]
      @round_trip            = params[:round_trip]
      @adults                = params[:quantity_adults].to_i
      @kids                  = params[:quantity_kids].to_i
      @seats                 = @adults + @kids
      @flight_origin_tour_picker = params[:flight_origin_tour_picker]
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
