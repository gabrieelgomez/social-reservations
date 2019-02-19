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
          session[:square_circuit]   = params[:square_circuit].first.select{|_, value| !value.empty?}
          redirect_to checkout_path(params[:lang], params[:currency])
        end

        def create_reservation_circuit
          if session[:reservation].nil? || session[:square_circuit].nil?
            redirect_to errors_checkout_path('usd')
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
            build_square
            if @reservation.save!
              @reservation.order.update(
                details: 'circuit',
                price_total_pax: @price_total,
                user_referer: @user.email,
              )
              create_travellers
              ReservationMailer.circuit_status(@reservation, @user).deliver_now
              ReservationMailer.to_admin_circuit(@reservation, @user).deliver_now

              # redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
              redirect_to invoice_path('es', 'usd')
            else
              render :new
            end
          end
        end

        def build_square
          square = session[:square_circuit]
          @square = KepplerTravel::Square.create!(
            single:     square['single'].to_i     || 0,
            doubles:    square['doubles'].to_i    || 0,
            triples:    square['triples'].to_i    || 0,
            quadruples: square['quadruples'].to_i || 0,
            quintuples: square['quintuples'].to_i || 0,
            sextuples:  square['sextuples'].to_i  || 0,
            children:   square['children'].to_i   || 0,
            ranking_id: square['ranking_id'].to_i,
            reservation: @reservation,
            squareable_id: @reservation.reservationable.id,
            squareable_type: @reservation.reservationable.class.to_s
          )
        end

        private

        def calculate_price
          circuitable = @reservation.reservationable.circuitables.find_by(ranking_id: session[:square_circuit]['ranking_id'])

          table = circuitable.price_table(session[:square_circuit], session[:invoice].first['currency'])
          @price_total = table.last[:total_price_table]
        end

      end

    end
  end
end
