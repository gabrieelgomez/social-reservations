module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_lang_currency
    before_action :set_module
    before_action :set_all_services_plans, only: %i[index multidestinations_all tours_all circuits_all]
    before_action :payment_gateway, only: %i[invoice]
    before_action :set_search, only: %i[index circuits multidestinations reservations tours vehicles]
    before_action :set_params_widget, only: %i[circuits multidestinations tours vehicles]
    before_action :delete_session,    except: %i[checkout
      create_reservation_transfer session_reservation_transfer
      create_reservation_tour session_reservation_tour
      create_reservation_circuit session_reservation_circuit
      create_reservation_multidestination session_reservation_multidestination]

    include DeleteSession
    include PaymentProcess
    include Widget

    def set_locale_lang
      @locale = request.protocol + request.host_with_port + '/en'
    end

    def index; end

    def vehicles
      @destination = @KT::Destination.ransack(title_cont: @locality[0]).result.first
      @results     = @destination.vehicles.ransack(seat_gteq: @seats).result if @destination
      @cotization  = true if @departament[0] != @departament[1]

      unless current_user.nil?
        @cotization  = true if current_user.is_from_colombia?
      end

      respond_to do |format|
        if @results.nil?
          format.json { render json: @results, status: 200 }
        else
          format.json { render json: @results, each_serializer: KepplerTravel::VehicleSerializer, cotization: @cotization, locality: @locality, currency: @currency, status: 200 }
        end

        format.html
      end
    end

    def tours
      @results = @KT::Tour.find(params[:tour_id])
    end

    def circuits
      @results = @KT::Circuit.find(params[:circuit_id])
    end

    def multidestinations
      @results = @KT::Multidestination.find(params[:multidestination_id])
    end

    def multidestinations_all; end

    def tours_all; end

    def circuits_all; end

    def about; end

    def contact_us
      @message = KepplerContactus::Message.new
    end

    def pqrs
      @message = KepplerContactus::Request.new
    end

    # Step 4
    def errors; end

    # Step 5
    def invoice; end

    private

    def set_module
      @KT = KepplerTravel
    end

    def set_all_services_plans
      @vehicles          = @KT::Vehicle.all
      @tours             = @KT::Tour.all
      @circuits          = @KT::Circuit.all
      @multidestinations = @KT::Multidestination.all
    end

    def set_lang_currency
      @currency = params[:currency]
      @lang     = params[:locale]
      unless current_user.nil?
        @currency = 'cop' if current_user.has_role?(:agency) || current_user.has_role?(:agent)
      end
    end

  end
end
