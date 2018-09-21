# module App::Reservations::Tours
#   class ToursController < CreateController
#
#     # POST /reservations
#     def session_reservation_tour
#       session[:reservation] = KepplerTravel::Reservation.new(reservation_params)
#       session[:user]        = params[:user]
#       session[:invoice]     = params[:invoice]
#       session[:travellers]  = params[:travellers]
#       session[:reservationable]  = {type:'tour', id:params[:reservationable_id]}
#       redirect_to checkout_path(params[:lang], params[:currency])
#     end
#
#     def create_reservation_tour
#       @reservation = KepplerTravel::Reservation.new(session[:reservation])
#       find_or_create_user
#       @reservation.status = :pending
#       @reservation.user = @user
#       @reservation.reservationable = KepplerTravel::Tour.find session[:reservationable]['id']
#       @price_total = @reservation.reservationable.price_adults
#       build_invoice
#       if @reservation.save!
#         create_travellers
#         # ReservationMailer.tour_status(@reservation, @user).deliver_now
#         redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
#       else
#         render :new
#       end
#
#     end
#
#
#   end
# end

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
          @reservation = KepplerTravel::Reservation.new(session[:reservation])
          find_or_create_user
          @reservation.status = :pending
          @reservation.user = @user
          @reservation.reservationable = KepplerTravel::Tour.find session[:reservationable]['id']
          @price_total = @reservation.reservationable.price_adults
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

    end
  end
end
