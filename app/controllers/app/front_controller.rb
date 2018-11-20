module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_lang_currency
    before_action :set_search, only: %i[index circuits multidestinations reservations tours vehicles]
    before_action :set_params_widget, only: %i[circuits multidestinations tours vehicles]
    before_action :delete_session,    except: %i[checkout
      create_reservation_transfer session_reservation_transfer
      create_reservation_tour session_reservation_tour
      create_reservation_circuit session_reservation_circuit
      create_reservation_multidestination session_reservation_multidestination]

    def set_locale_lang
      @locale = request.protocol + request.host_with_port + '/es'
    end

    def index
      @vehicles = KepplerTravel::Vehicle.all
      @tours    = KepplerTravel::Tour.all
      @circuits = KepplerTravel::Circuit.all
      @multidestinations = KepplerTravel::Multidestination.all
    end

    def vehicles
      # byebug
      @destination = KepplerTravel::Destination.ransack(title_cont: @locality[0]).result.first
      @results     = @destination.vehicles.ransack(seat_gteq: @seats).result if @destination
      @cotization  = true if @departament[0] != @departament[1]
    end

    def tours
      @results = KepplerTravel::Tour.find(params[:tour_id])
    end

    def circuits
      @results = KepplerTravel::Circuit.find(params[:circuit_id])
    end

    def multidestinations
      @results = KepplerTravel::Multidestination.find(params[:multidestination_id])
    end

    def errors
    end

    # Step 4
    def invoice
      referencia = params[:referencia]
      moenda = params[:moenda]
      valor = params[:valor]
      repuesta = params[:repuesta]
      cuentanro = params[:cuentanro]
      autorizacion = params[:autorizacion]
      nrotransaccion = params[:nrotransaccion]
      extra = params[:extra]

      if respuesta == 'aprobada'
        invoice = KepplerTravel::Invoice.find_by(token: referencia)
        invoice.update(status: 'approved')
        if invoice.reservation.update(status: 'approved')
          PaymentMailer.payment(invoice.reservation, invoice.reservation.user).deliver_now
        end
      end

    end

    # Step 4
    def gracias
    end


    def about
    end

    def payment
    end

    def break_error
    end

    def contact_us
    end

    def pqrs
      @message = KepplerContactus::Request.new
    end

    private

    def set_search
      @destinations = KepplerTravel::Destination.all
      @q = KepplerTravel::Vehicle.ransack(params[:q])
    end

    def set_params_widget
      @locality              = [params[:origin_locality], params[:arrival_locality]]
      @departament           = [params[:origin_departament], params[:arrival_departament]]
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
      @flight_origin_tour_picker = params[:flight_origin_tour_picker] || params[:flight_tour_data]
      @flight_origin_circuit_picker = params[:flight_origin_circuit_picker] || params[:flight_circuit_data]
      @flight_origin_multidestination_picker = params[:flight_origin_multidestination_picker] || params[:flight_multidestination_data]
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
