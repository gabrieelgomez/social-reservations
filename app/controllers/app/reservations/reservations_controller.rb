module App
  module Reservations
    class ReservationsController < FrontController
      # layout 'app/layouts/application'
      before_action :set_search, only: :reservations
      before_action :set_params_widget, only: :reservations
      before_action :set_reservationable, only: :reservations
      # before_action :delete_session, except: %i[checkout]

      # Step 1
      def reservations
        @reservation = KepplerTravel::Reservation.new
      end

      # Step 2
      def checkout
        @reservation     = session[:reservation]
        @travellers      = session[:travellers].try(:first)
        @user            = session[:user].try(:first) || current_user
        @invoice         = session[:invoice].try(:first)
        @reservationable = session[:reservationable]

        if @reservation.nil?
          redirect_to errors_checkout_path(@lang, @currency)
        else
          # -----
          case @reservationable['type']
            when 'vehicle'
              set_vehicle_checkout
            when 'tour'
              set_tour_checkout
            when 'circuit'
              set_circuit_checkout
            when 'multidestination'
              set_multidestination_checkout
          end
          # -----
        end

      end

      # Step 3
      def transaction_payment
        @reservation         = KepplerTravel::Reservation.find(params[:reservation_id]) rescue nil
        @invoice             = @reservation.try(:invoice)
        @user                = @reservation.try(:user)
        @reservationable     = @reservation.try(:reservationable)
        if @reservation.nil?
          redirect_to errors_checkout_path('cop')
        else
          redirect_to root_path if @invoice.status_pay? :approved
        end
      end

      # Step 4
      def invoice
      end

      private
      # Set by Step 1
      def set_reservationable
        @render = params[:reservationable_type].downcase.pluralize
        case params[:reservationable_type]
          when 'vehicle'
            @vehicle      = KepplerTravel::Vehicle.find params[:reservationable_id]
            @kit_quantity = @vehicle.kit['quantity']
          when 'tour'
            @tour = KepplerTravel::Tour.find params[:reservationable_id]
            set_price_tour
          when 'circuit'
            @circuit = KepplerTravel::Circuit.find params[:reservationable_id]
            @rankings = @circuit.circuitable_rooms.as_json(
              methods: %i[ranking_id type_room]
            )
          when 'multidestination'
            @multidestination = KepplerTravel::Multidestination.find params[:reservationable_id]
            @lodgments = @multidestination.multidestinationable_rooms.as_json(
              methods: %i[lodgment_id type_room]
            )
        end
      end

      # Set by Step 1
      def set_price_tour
        @total_adults    = @tour.price_adults[@currency].to_f * @adults
        @total_kids      = @tour.calculate_kids(@kids, @currency) * @kids
        @total_price     = @total_adults + @total_kids
      end

      # Set by Step 2 Vehicle
      def set_vehicle_checkout
        @render          = 'vehicles'
        @locality        = [@reservationable['origin_locality'], @reservationable['arrival_locality']]
        @reservationable = KepplerTravel::Vehicle.find(@reservationable['id'])
        @multiple        = KepplerTravel::Reservation.multiple(@reservation)
        @price_total     = KepplerTravel::Reservation.price_total(@locality, @reservation, @reservationable, @currency)
      end

      # Set by Step 2 Tour
      def set_tour_checkout
        @render          = 'tours'
        @reservationable = KepplerTravel::Tour.find(@reservationable['id'])
      end

      # Set by Step 2 Circuit
      def set_circuit_checkout
        @render          = 'circuits'
        @reservationable = KepplerTravel::Circuit.find(@reservationable['id'])
      end

      # Set by Step 2 Multidestination
      def set_multidestination_checkout
        @render          = 'multidestinations'
        @reservationable = KepplerTravel::Multidestination.find(@reservationable['id'])
      end

    end
  end
end
