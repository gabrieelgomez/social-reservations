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
          session[:reservationable]  = {
            type: 'vehicle',
            id: params[:reservationable_id],
            origin_locality: params[:origin_locality],
            arrival_locality: params[:arrival_locality],
            origin_departament: params[:origin_departament],
            arrival_departament: params[:arrival_departament],
            cotization: params[:cotization]
          }
          redirect_to checkout_path(params[:lang], params[:currency])
        end

        def create_reservation_transfer
          if session[:reservation].nil?
            redirect_to errors_checkout_path('usd')
          else
            @reservation = KepplerTravel::Reservation.new(session[:reservation])
            find_or_create_user
            @reservation.status = :pending
            @reservation.user = @user
            @reservation.reservationable = KepplerTravel::Vehicle.find session[:reservationable]['id']
            @currency = session[:invoice].first['currency']
            set_price
            build_invoice
            if @reservation.save!
              create_travellers
              ReservationMailer.transfer_status(@reservation, @user).deliver_now
              if current_user.try(:has_role?, :agency)
                redirect_to invoice_path('es', 'usd')
              elsif @price_total != nil
                redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
              else
                redirect_to invoice_path('es', 'usd')
              end
            else
              render :new
            end
          end
        end


        private

        def set_price
          @round_trip = session[:reservation]['round_trip']
          @vehicle    = @reservation.reservationable
          # departament = [session[:reservationable]['origin_departament'], session[:reservationable]['arrival_departament']]
          @locality = [session[:reservationable]['origin_locality'], session[:reservationable]['arrival_locality']]
          @cotization = session[:reservationable]['cotization']
          unless @cotization == 'true'
            @price_total     = @round_trip == 'true' ? @vehicle.set_price_destination(@locality, @currency).to_f*2 : @vehicle.set_price_destination(@locality, @currency).to_f
          else
            @cotization  = true
            @price_total = nil
          end

          set_price_agency
        end

      end

    end
  end
end
