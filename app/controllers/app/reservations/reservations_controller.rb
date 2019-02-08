module App
  module Reservations
    class ReservationsController < FrontController
      # layout 'app/layouts/application'
      before_action :set_search, only: :reservations
      before_action :set_params_widget, only: :reservations
      before_action :set_reservationable, only: :reservations

      include ReservationsQuery

      # Step 1
      def reservations
        @reservation = @KT::Reservation.new
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
            when 'circuit'
              set_circuit_checkout
            when 'multidestination'
              set_multidestination_checkout
          end
          # -----
        end

      end

      # Step 3
      def transaction_payment
        @reservation         = @KT::Reservation.find(params[:reservation_id]) rescue nil
        @invoice             = @reservation.try(:invoice)
        @user                = @reservation.try(:user)
        @reservationable     = @reservation.try(:reservationable)
        if @reservation.nil?
          redirect_to errors_checkout_path('usd')
        else
          redirect_to root_path if @invoice.status_pay? :approved
        end
      end

    end
  end
end
