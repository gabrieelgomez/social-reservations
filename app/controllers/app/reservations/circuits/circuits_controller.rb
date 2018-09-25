module App
  module Reservations
    module Circuits

      class CircuitsController < CreateController
        # POST /reservations
        def session_reservation_circuit
          session[:reservation] = KepplerTravel::Reservation.new(reservation_params)
          session[:user]        = params[:user]
          session[:invoice]     = params[:invoice]
          session[:travellers]  = params[:travellers]
          session[:reservationable]  = {type:'circuit', id:params[:reservationable_id]}
          redirect_to checkout_path(params[:lang], params[:currency])
        end

        def create_reservation_circuit
          if session[:reservation].nil?
            redirect_to errors_checkout_path('cop')
          else
            @reservation = KepplerTravel::Reservation.new(session[:reservation])
            find_or_create_user
            @reservation.status = :pending
            @reservation.user = @user
            @reservation.reservationable = KepplerTravel::Circuit.find session[:reservationable]['id']

            # Calculate Price
            calculate_price
            # Calculate Price

            build_invoice
            if @reservation.save!
              create_travellers
              # ReservationMailer.circuit_status(@reservation, @user).deliver_now
              redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
            else
              render :new
            end
          end
        end

        private

        def calculate_price
          adults = session[:reservation]['quantity_adults']
          kids   = session[:reservation]['quantity_kids']
          @total_adults    = @reservation.reservationable.price * adults
          # @total_kids      = @reservation.reservationable.calculate_kids(kids) * kids
          @price_total     = @total_adults# + @total_kids
        end

      end

    end
  end
end
