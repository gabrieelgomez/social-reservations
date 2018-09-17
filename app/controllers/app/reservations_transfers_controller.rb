module App
  # FrontsController
  class ReservationsTransfersController < FrontController
    layout 'layouts/templates/application'

    # POST /reservations
    def session_reservation_transfer
      session[:reservation] = KepplerTravel::Reservation.new(reservation_params)
      session[:vehicle]     = KepplerTravel::Vehicle.find params[:vehicle_id]
      session[:user]        = params[:user]
      session[:invoice]     = params[:invoice]
      session[:travellers]  = params[:travellers]
      redirect_to checkout_path(params[:lang], params[:currency])
    end

    def create_reservation_transfer
      @reservation = KepplerTravel::Reservation.new(session[:reservation])
      find_or_create_user
      @reservation.status = :pending
      @reservation.user = @user
      @reservation.reservationable = KepplerTravel::Vehicle.find session[:vehicle]['id']
      build_invoice
      if @reservation.save!
        create_travellers
        ReservationMailer.transfer_status(@reservation, @user).deliver_now
        # redirect(@reservation, params)
        redirect_to checkout_elp_redirect_path(@reservation.id, @reservation.invoice.id)
      else
        render :new
      end
    end

    def build_invoice
      currency = session[:invoice].first['currency']
      @reservation.build_invoice(
        token: session[:invoice].first['token'],
        address: session[:invoice].first['address'],
        amount: @reservation.reservationable.price[currency],
        currency: currency,
        status: :pending
      )
    end

    def find_or_create_user
      # if user not loggeding
      unless current_user
        # each params user
        @user_session = session[:user].first
        @user = User.find_by(email: @user_session['email'])

        # if user.nil?
        unless @user
          password = Devise.friendly_token.first(8)
          @user = User.create(
            name: @user_session['name'],
            email: @user_session['email'],
            dni: @user_session['dni'],
            phone: @user_session['phone'],
            password: '123123123',
            password_confirmation: password,
            password: password
          )
          @user.add_role :client
          @user.format_accessable_passwd(password)
          ReservationMailer.send_password(@user).deliver_now
        end

      else
        @user = current_user
      end
      @user.add_role :client
    end

    def create_travellers
      KepplerTravel::Traveller.create(
        name: session[:travellers].first['name'],
        dni: session[:travellers].first['dni'],
        reservation: @reservation
      )
    end

    private

    # Only allow a trusted parameter "white list" through.
    def reservation_params
      params.require(:reservation).permit(:origin, :arrival, :origin_location, :arrival_location,
                                          :airline_origin, :airline_arrival, :flight_number_origin, :flight_number_arrival,
                                          :flight_origin, :flight_arrival, :quantity_adults, :quantity_kids, :description,
                                          :quantity_kit, :round_trip, :airport_origin, :position, :deleted_at,
                                          travellers_attributes: [:name, :dni])
    end

  end
end
