module KepplerTravel

  module Reservations
    # FrontsController
    class TransfersController < ApplicationController
      layout 'layouts/templates/application'

      # POST /reservations
      def create_reservations_transfers
        @reservation = Reservation.new(reservation_params)
        find_or_create_user
        @reservation.user = @user
        @reservation.vehicle = Vehicle.find params[:vehicle_id]
        if @reservation.save!
          create_travellers
          KepplerTravel::ReservationMailer.send_password(@user).deliver_now
          # redirect(@reservation, params)
          # redirect_to main_app.root_path
        else
          render :new
        end
      end

      def find_or_create_user
        unless current_user
          params[:user].each do |user|
            @user = User.find_by(email: user[:email])
            unless @user
              password = Devise.friendly_token.first(8)
              @user = User.create(
                name: user[:name],
                email: user[:email],
                dni: user[:dni],
                phone: user[:phone],
                password: '123123123',
                password_confirmation: password,
                password: password
              )
              @user.add_role :client
              @user.format_accessable_passwd(password)
            end
          end

        else
          @user = current_user
        end

      end

      def create_travellers
        params[:travellers].each do |traveller|
          Traveller.create(
            name: traveller[:name],
            dni: traveller[:dni],
            reservation: @reservation
          )
        end
      end

      # Only allow a trusted parameter "white list" through.
      def reservation_params
        params.require(:reservation).permit(:origin, :arrival, :origin_location, :arrival_location, :invoice_address,
                                            :airline_origin, :airline_arrival, :flight_number_origin, :flight_number_arrival,
                                            :flight_origin, :flight_arrival, :quantity_adults, :quantity_kids, :description,
                                            :quantity_kit, :round_trip, :airport_origin, :position, :deleted_at,
                                            travellers_attributes: [:name, :dni])
      end

    end
  end

end
