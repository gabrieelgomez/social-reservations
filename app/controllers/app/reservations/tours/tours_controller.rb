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
            @reservation.build_order(
              details: 'user',
              price_reservationable: @price_reservationable,
              price_total_pax: @price_total_pax,
              user_referer: @user.email,
              status: 'pending'
            )
            if @reservation.save!
              create_travellers
              if current_user.try(:has_role_agentable?)

                if @reservation.order.update(
                  details: 'agency',
                  agency: @agency,
                  agent: @agent,
                  comission: @comission,
                  lending: @lending,
                  price_comission: @price_comission,
                  price_lending: @price_lending,
                  price_total_agency: @price_total_agency,
                  price_total_pax: @price_total_pax,
                  agency_referer: @agency.id,
                  agent_referer: @agent&.id
                )

                  ReservationMailer.tour_status(@reservation, current_user).deliver_now
                  ReservationMailer.to_admin_tour(@reservation, current_user).deliver_now
                  redirect_to invoice_path('es', 'usd')
                else
                  redirect_to errors_checkout_path('usd')
                end
              else
                # ReservationMailer.tour_status(@reservation, @user).deliver_now
                redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
              end
            else
              redirect_to errors_checkout_path('usd')
            end
          end
        end

        private

        def calculate_price
          adults = session[:reservation]['quantity_adults']
          kids   = session[:reservation]['quantity_kids']
          currency = session[:invoice].first['currency']
          @price_adults = @reservation.reservationable.price_adults[currency].to_f
          @price_kids   = @reservation.reservationable.calculate_kids(currency).to_f
          @total_adults = @price_adults * adults
          @total_kids   = @price_kids   * kids
          @price_total  = @total_adults + @total_kids
          @price_reservationable = @price_adults
          @price_total_pax = @price_total
          set_price_agency
        end

      end

    end
  end
end
