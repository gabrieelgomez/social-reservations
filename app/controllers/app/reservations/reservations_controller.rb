module App
  module Reservations
    class ReservationsController < FrontController
      # layout 'app/layouts/application'
      before_action :set_reservationable, only: :reservations

      # Step 1
      def reservations
        @reservation = KepplerTravel::Reservation.new
        @flight_origin_tour_picker = params[:flight_origin_tour_picker]
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
              # set_price_tour
            when 'circuits'
              nil
            when 'multidestinations'
              nil
          end
          # -----
        end

      end

      # Step 3
      def transaction_payment
        @reservation         = KepplerTravel::Reservation.find params[:reservation_id]
        @invoice             = @reservation.invoice
        @user                = @reservation.user
        @reservationable     = @reservation.reservationable
        redirect_to root_path if @invoice.status_pay? :approved
      end

      # Step 4
      def invoice
        byebug
      end

      private

      # Set by Step 1
      def set_reservationable
        @render = params[:reservationable_type].downcase.pluralize
        @adults      = params[:adults].to_i
        @kids        = params[:kids].to_i
        @seats       = @adults + @kids
        case params[:reservationable_type]
          when 'vehicle'
            @vehicle      = KepplerTravel::Vehicle.find params[:reservationable_id]
            @kit_quantity = @vehicle.kit['quantity']
          when 'tour'
            @tour = KepplerTravel::Tour.find params[:reservationable_id]
            set_price_tour
          when 'circuits'
            nil
          when 'multidestinations'
            nil
        end
      end

      # Set by Step 1
      def set_price_tour
        @total_adults    = @tour.price_adults * @adults
        @total_kids      = @tour.calculate_kids(@kids) * @kids
        @total_price     = @total_adults + @total_kids
      end

      # Set by Step 2 Vehicle
      def set_vehicle_checkout
        @render          = 'vehicles'
        @reservationable = KepplerTravel::Vehicle.find(@reservationable['id'])
        @multiple        = KepplerTravel::Reservation.multiple(@reservation)
        @price_total     = KepplerTravel::Reservation.price_total(@reservation, @reservationable, @currency)
      end

      # Set by Step 2 Tour
      def set_tour_checkout
        @render          = 'tours'
        @reservationable = KepplerTravel::Tour.find(@reservationable['id'])
      end

    end
  end
end
