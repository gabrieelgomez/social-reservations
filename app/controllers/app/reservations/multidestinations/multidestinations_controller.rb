module App
  module Reservations
    module Multidestinations

      class MultidestinationsController < CreateController
        # POST /reservations
        def session_reservation_multidestination
          session[:reservation] = KepplerTravel::Reservation.new(reservation_params)
          session[:user]        = params[:user]
          session[:invoice]     = params[:invoice]
          session[:travellers]  = params[:travellers]
          session[:reservationable]  = {
            type:'multidestination',
            id:params[:reservationable_id],
            total_kids_per: params[:total_kids_per],
            total_rooms_per: params[:total_rooms_per]
          }
          session[:square_multidestination]  = params[:square_multidestination].first.select{|_, value| !value.empty?}

          redirect_to checkout_path(params[:lang], params[:currency])
        end

        def create_reservation_multidestination
          if session[:reservation].nil? || session[:square_multidestination].nil?
            redirect_to errors_checkout_path('usd')
          else

            @reservation = KepplerTravel::Reservation.new(session[:reservation])
            find_or_create_user
            @reservation.status = :pending
            @reservation.user = @user
            @reservation.reservationable = KepplerTravel::Multidestination.find session[:reservationable]['id']

            # Calculate Price
            calculate_price
            # Calculate Price
            build_invoice
            build_square
            @reservation.build_order(details: 'user', status: 'pending')
            if @reservation.save!
              @reservation.order.update(
                details: 'multidestination',
                table_reservationable: session[:table_reservationable],
                price_total_pax: @price_total,
                user_referer: @user.email,
              )
              create_travellers
              ReservationMailer.multidestination_status(@reservation, @user).deliver_now
              ReservationMailer.to_admin_multidestination(@reservation, @user).deliver_now
              # redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
              redirect_to invoice_path('en', 'usd')
            else
              render :new
            end
          end
        end

        def build_square
          square = session[:square_multidestination]
          @square = KepplerTravel::Square.create!(
            single:     square['single'].to_i     || 0,
            doubles:    square['doubles'].to_i    || 0,
            triples:    square['triples'].to_i    || 0,
            quadruples: square['quadruples'].to_i || 0,
            quintuples: square['quintuples'].to_i || 0,
            sextuples:  square['sextuples'].to_i  || 0,
            children:   square['children'].to_i   || 0,
            lodgment_id: square['lodgment_id'].to_i,
            reservation: @reservation,
            squareable_id: @reservation.reservationable.id,
            squareable_type: @reservation.reservationable.class.to_s
          )
        end

        private

        def calculate_price
          multidestinationable = @reservation.reservationable.multidestinationables.find_by(lodgment_id: session[:square_multidestination]['lodgment_id'])
          # table = multidestinationable.price_table(session[:square_multidestination], session[:invoice].first['currency'])
          # @price_total = table.last[:total_price_table]
          total = session[:reservationable]['total_rooms_per'].to_f + session[:reservationable]['total_kids_per'].to_f
          @price_total = total
        end

      end

    end
  end
end
