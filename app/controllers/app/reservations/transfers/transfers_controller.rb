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
            @reservation.build_order(
              details: 'user',
              status: 'pending',
              price_reservationable: @price_reservationable,
              price_total_pax: @price_total_pax,
              user_referer: @user.email
            )
            if @reservation.save!
              create_travellers
              if current_user.try(:has_role_agentable?)
                @reservation.order.update(
                  details: 'agency',
                  agency: @agency,
                  agent: @agent,
                  comission: @comission,
                  lending: @lending,
                  price_comission: @price_comission,
                  price_lending: @price_lending,
                  price_total_agency: @price_total_agency,
                  agency_referer: @agency.id,
                  agent_referer: @agent&.id
                )
                ReservationMailer.transfer_status(@reservation, @user).deliver_now
                redirect_to invoice_path('en', 'usd')
              elsif @price_total.zero?
                ReservationMailer.transfer_status(@reservation, @user).deliver_now
                redirect_to invoice_path('en', 'usd')
              else
                redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
              end
            else
              redirect_to errors_checkout_path('usd')
            end
          end
        end


        private

        def set_price
          @round_trip = session[:reservation]['round_trip']
          @vehicle    = @reservation.reservationable
          @locality = [session[:reservationable]['origin_locality'], session[:reservationable]['arrival_locality']]
          @cotization = session[:reservationable]['cotization']
          unless @cotization == 'true'
            @price_reservationable   = @vehicle.set_price_destination(@locality, @currency).to_f
            @price_total             = @round_trip == 'true' ? @price_reservationable*2 : @price_reservationable
            @price_total_pax         = @price_total
          else
            @cotization  = true
            @price_total = 0
          end

          set_price_agency
        end

      end

    end
  end
end
