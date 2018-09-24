module App
  module Reservations
    module Transfers

      class TransfersController < CreateController
        # POST /reservations
        def session_reservation_transfer
          session[:reservation] = KepplerTravel::Reservation.new(reservation_params)
          session[:user]        = params[:user]
          session[:invoice]     = params[:invoice]
          session[:travellers]  = params[:travellers]
          session[:reservationable]  = {type:'vehicle', id:params[:reservationable_id]}
          redirect_to checkout_path(params[:lang], params[:currency])
        end

        def create_reservation_transfer
          if session[:reservation].nil?
            redirect_to errors_checkout_path('cop')
          else
            @reservation = KepplerTravel::Reservation.new(session[:reservation])
            find_or_create_user
            @reservation.status = :pending
            @reservation.user = @user
            @reservation.reservationable = KepplerTravel::Vehicle.find session[:reservationable]['id']
            @currency = session[:invoice].first['currency']
            @price_total = @reservation.reservationable.price[@currency]
            build_invoice
            if @reservation.save!
              create_travellers
              ReservationMailer.transfer_status(@reservation, @user).deliver_now
              redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
            else
              render :new
            end
          end
        end

      end

    end
  end
end
