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
            arrival_departament: params[:arrival_departament]
          }
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
            set_price
            build_invoice
            if @reservation.save!
              create_travellers
              ReservationMailer.transfer_status(@reservation, @user).deliver_now
              if @price_total != 1
                redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
              else @price_total == 1
                redirect_to invoice_path('es', 'cop')
              end
            else
              render :new
            end
          end
        end


        private

        def set_price
          departament = [session[:reservationable]['origin_departament'], session[:reservationable]['arrival_departament']]
          locality = [session[:reservationable]['origin_local'], session[:reservationable]['arrival_locality']]
          if departament[0] == departament[1]
            vehicleables = @reservation.reservationable.vehicleables
            @destiny = vehicleables.ransack(title_cont: locality[0]).result.first
            @destiny = vehicleables.ransack(title_cont: locality[1]).result.first if @destiny.nil?
            if locality[0] == locality[1]
              price = @destiny.try("price_inner_#{@currency}")
            else
              price = @destiny.try("price_outer_#{@currency}")
            end
            @price_total = price
          elsif departament[0] != departament[1]
            @cotization     = true
            @price_total = 1
          end
        end

      end

    end
  end
end
