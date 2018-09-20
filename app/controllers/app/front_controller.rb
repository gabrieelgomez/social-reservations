module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_search, only: [:index, :vehicles, :tours, :reservations]
    before_action :set_params_widget, only: [:vehicles, :tours]
    before_action :set_reservationable, only: :reservations
    before_action :set_lang_currency
    before_action :delete_session, except: [:checkout, :create_reservation_transfer, :session_reservation_transfer]

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

    def reservations
      @reservation = KepplerTravel::Reservation.new
      @adults = params[:adults]
      @kids   = params[:kids]
      @seats = @adults.to_i + @kids.to_i
    end

    def checkout
      @reservation = session[:reservation]
      @travellers  = session[:travellers].try(:first)
      @user        = session[:user].try(:first) || current_user
      @vehicle     = session[:vehicle]
      @invoice     = session[:invoice].try(:first)
      @multiple    = @reservation['round_trip'] == 'true' ? '2' : '1'
      @price_total = @reservation['round_trip'] == 'true' ? @vehicle['price'][@currency].to_f*2 : @vehicle['price'][@currency].to_f
    end

    def invoice
      byebug
    end

    def transaction_payment
      @reservation = KepplerTravel::Reservation.find params[:reservation_id]
      @invoice     = @reservation.invoice
      @reservationable     = @reservation.reservationable
      @user = @reservation.user
    end

    private

    def set_search
      @destinations = KepplerTravel::Destination.all
      @q = KepplerTravel::Vehicle.ransack(params[:q])
    end

    def set_reservationable
      @render = params[:reservationable_type].downcase.pluralize
      case params[:reservationable_type]
      when 'Vehicle'
        @vehicle = KepplerTravel::Vehicle.find params[:reservationable_id]
        @kit_quantity = @vehicle.kit['quantity']
      when 'Tour'
        @tour = KepplerTravel::Tour.find params[:reservationable_id]
      when 'Circuits'
        nil
      when 'Multidestinations'
        nil
      end
    end

    def set_params_widget
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
    end

    def set_lang_currency
      @currency = params[:currency]
      @lang     = params[:locale]
    end

    def delete_session
      session.delete(:reservation)
      session.delete(:travellers)
      session.delete(:user)
      session.delete(:vehicle)
      session.delete(:invoice)
    end

  end
end
