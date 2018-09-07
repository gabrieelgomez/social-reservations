module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_search, only: [:index, :vehicles, :reservations]
    before_action :set_vehicle, only: :reservations
    before_action :set_lang_currency
    before_action :delete_session, except: [:invoice, :create_reservation_transfer, :session_reservation_transfer]


    def set_locale_lang
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


    def invoice
      @reservation = KepplerTravel::Reservation.new
      @reservation = session[:reservation]
      @travellers  = session[:travellers].first
      @user        = session[:user].try(:first) || current_user
      @vehicle     = session[:vehicle]
      @token       = session[:reservation_token]
      @multiple    = @reservation['round_trip'] == 'true' ? '2' : '1'
      @price_total = @reservation['round_trip'] == 'true' ? @vehicle['price'][@currency].to_f*2 : @vehicle['price'][@currency].to_f
    end

    private

    def set_search
      @destinations = KepplerTravel::Destination.all
      @q = KepplerTravel::Vehicle.ransack(params[:q])
    end

    def set_vehicle
      @vehicle = KepplerTravel::Vehicle.find params[:vehicle_id]
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
      session.delete(:reservation_token)
    end

  end
end
