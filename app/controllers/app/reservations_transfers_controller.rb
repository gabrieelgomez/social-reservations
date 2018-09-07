module App
  # FrontsController
  class ReservationsTransfersController < FrontController
    layout 'layouts/templates/application'

    # POST /reservations
    def create_reservations_transfers
      session[:reservation] = KepplerTravel::Reservation.new(reservation_params)
      session[:travellers]  = params[:travellers]
      session[:user]        = params[:user]
      session[:vehicle]     = KepplerTravel::Vehicle.find params[:vehicle_id]
      session[:reservation_token] = params[:token]
      redirect_to invoice_transfer_path(params[:lang], params[:currency])
      # @reservation = KepplerTravel::Reservation.new(reservation_params)
      # find_or_create_user
      # @reservation.user = @user
      # @reservation.vehicle = KepplerTravel::Vehicle.find params[:vehicle_id]
      # if @reservation.save!
      #   create_travellers
      #   ReservationMailer.transfer_status(@reservation, @user).deliver_now
      #   # redirect(@reservation, params)
      #   # redirect_to main_app.root_path
      # else
      #   render :new
      # end
    end

    def find_or_create_user
      # if user not loggeding
      unless current_user

        # each params user
        params[:user].each do |user|
          @user = User.find_by(email: user[:email])

          # if user.nil?
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
            ReservationMailer.send_password(@user).deliver_now
          end

        end

      else
        @user = current_user
      end

    end

    def create_travellers
      params[:travellers].each do |traveller|
        KepplerTravel::Traveller.create(
          name: traveller[:name],
          dni: traveller[:dni],
          reservation: @reservation
        )
      end
    end

    private

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
