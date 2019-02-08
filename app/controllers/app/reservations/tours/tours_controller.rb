module App
  module Reservations
    module Tours

      class ToursController < CreateController
        # POST /reservations
        def session_reservation_tour
          session[:reservation] = KepplerTravel::Reservation.new(reservation_params)
          session[:user]        = params[:user]
          session[:invoice]     = params[:invoice]
          session[:travellers]  = params[:travellers]
          session[:reservationable]  = {type:'tour', id:params[:reservationable_id]}
          redirect_to checkout_path(params[:lang], params[:currency])
        end

        def create_reservation_tour
          if session[:reservation].nil?
            redirect_to errors_checkout_path('usd')
          else
            @reservation = KepplerTravel::Reservation.new(session[:reservation])
            find_or_create_user
            @reservation.status = :pending
            @reservation.user = @user
            @reservation.reservationable = KepplerTravel::Tour.find session[:reservationable]['id']

            # Calculate Price
            calculate_price
            # Calculate Price

            build_invoice
            if @reservation.save!
              create_travellers
              # ReservationMailer.tour_status(@reservation, @user).deliver_now
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
          currency = session[:invoice].first['currency']
          @total_adults    = @reservation.reservationable.price_adults[currency].to_f * adults
          @total_kids      = @reservation.reservationable.calculate_kids(kids, currency) * kids
          @price_total     = @total_adults + @total_kids
        end

      end

    end
  end
end
